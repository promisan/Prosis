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
<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM UserReport
	  WHERE  ParentReportId = '#URL.ReportId#'
	  AND    Account = '#URL.Account#'
	</cfquery>
	
	<cfquery name="Address" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * FROM UserNames
	  WHERE  Account = '#URL.Account#'	  
	</cfquery>
	
	<cfif Address.eMailAddress neq "">
	    <cfset mail = address.eMailAddress>
	<cfelse>
	    <cfset mail = address.eMailAddressExternal> 
	</cfif>
	
	<cf_assignid>
		
	<cfquery name="InsertReport" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO UserReport
		
		    (	ReportId,					
				Account, 
				NodeIP,
				AccountSubscriber,
				ParentReportId,
				LayoutId, 
				DistributionName, 
				DistributionSubject, 
				DistributionEMail, 				
				DistributionReplyTo, 
				DistributionMode, 
	            FileFormat, 
				DistributionPeriod, 
				DistributionDOW, 
				DistributionDOM, 
				DateEffective, 
				DateExpiration, 
				Status, 
				ShowPopular, 
				OfficerUserId, 
				OfficerLastName, 
	            OfficerFirstName
			)
			
		SELECT 	 	'#rowguid#',		
					'#URL.Account#', 
					NodeIp,
					'#SESSION.acc#',
					ReportId,
					LayoutId, 
					DistributionName, 
					DistributionSubject, 
					'#mail#', 					
					DistributionReplyTo, 
					DistributionMode, 
    	    	    FileFormat, 
					DistributionPeriod, 
					DistributionDOW, 
					DistributionDOM, 
					DateEffective, 
					DateExpiration, 
					Status, 
					ShowPopular, 
					OfficerUserId, 
					OfficerLastName, 
	    	        OfficerFirstName			
		FROM        UserReport
		WHERE       ReportId = '#URL.reportid#'		
			
	</cfquery>	
	
	<cfquery name="InsertCriteria" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO UserReportCriteria (
				ReportId, 
			    CriteriaId, 
		    	CriteriaName, 
				CriteriaValue, 
				CriteriaValueDisplay )	
		SELECT     '#rowguid#', 
		           CriteriaId, 
				   CriteriaName, 
				   CriteriaValue, 
				   CriteriaValueDisplay
		FROM       UserReportCriteria
		WHERE      ReportId = '#URL.reportid#'		
	</cfquery>	
		
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM UserReport
	  WHERE  Account        = '#url.account#' 
	  AND    ParentReportId = '#URL.ReportId#'
	</cfquery>
		
</cfif>

<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   UserNames U, UserReport M
	  WHERE  ParentReportId = '#URL.ReportId#' 
	  AND    U.Account = M.Account
</cfquery>
	
<cfif user.recordcount gt "0">
	
    <table width="99%" align="center" class="navigation_table" style="background-color:ffffaf">	
					   
	   <cfoutput query="User">
	   			
			<tr class="labelmedium2 <cfif currentrow lt recordcount>line</cfif> navigation_row">
			   	  <td>#currentrow#.</td>
			      <td>#Account#</td>
				  <td>#FirstName# #LastName#</td>	 
				  <td>#DistributionEMail#</td>			 
				  <td>				    
				      <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Tools/CFReport/HTML/FormHTMLSubscriptionUser.cfm?reportid=#url.reportid#&action=delete&Account=#Account#','box#url.reportid#')">					 
				  </td>
			</tr>      
	       
	   </CFOUTPUT> 
   
   </table>
   
<cfelse>

	<cf_compression>   
   
</cfif>    

<cfset ajaxOnLoad("doHighlight")>  