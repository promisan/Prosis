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
<cfif url.id2 eq "" and url.id4 neq "">

	<cfquery name="ParentOrg" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM    Organization
		WHERE   Mission   = '#url.mission#' 
		AND     MandateNo = '#url.id4#'		
		ORDER BY HierarchyCode
	</cfquery>
	
	<cfset url.id2 = ParentOrg.OrgUnit>

</cfif>

<cfoutput>

	<cfswitch expression="#Role.Parameter#">
		
		  <cfcase value="Journal">
			   <cfinclude template="UserAccess_Journal.cfm"> 
		  </cfcase>
		  
		   <cfcase value="ProgramClass">
			   <cfinclude template="UserAccess_ProgramClass.cfm"> 
		  </cfcase>
		  
		  <cfcase value="CaseType">
		       <cfinclude template="UserAccess_CaseType.cfm">
		  </cfcase>
				  
		  <cfcase value="PostType">
		       <cfinclude template="UserAccess_Posttype.cfm">
		  </cfcase>
		  
		  <cfcase value="TaskType">
		       <cfinclude template="UserAccess_TaskType.cfm">
		  </cfcase>
		  
		   <cfcase value="LocationClass">
		       <cfinclude template="UserAccess_LocationClass.cfm">
		  </cfcase>
		  
		  <cfcase value="WardenZone">
		       <cfinclude template="UserAccess_WardenZone.cfm">
		  </cfcase>
		 
		  <cfcase value="Edition">
			   <cfinclude template="UserAccess_Edition.cfm">
		  </cfcase>
		  
		  <cfcase value="Module">
			   <cfinclude template="UserAccess_Module.cfm">
		  </cfcase>
		  
		  <cfcase value="EntryClass">
			   <cfinclude template="UserAccess_EntryClass.cfm">
		  </cfcase>
		  		  	  
		  <cfcase value="ServiceClass">
		       <cfinclude template="UserAccess_ServiceItem.cfm">
		  </cfcase>
		  
		  <cfcase value="ServiceItem">
		       <cfinclude template="UserAccess_ServiceItem.cfm">
		  </cfcase>
		  
	      <cfcase value="AccountGroup">
		       <cfinclude template="UserAccess_AccountGroup.cfm">
		  </cfcase>
		  
		  <cfcase value="Warehouse">
			   <cfinclude template="UserAccess_Warehouse.cfm">
		  </cfcase>
		 
		  <cfcase value="Owner">
		       <cfif Role.ParameterGroup eq "OccGroup">
			      <cfinclude template="UserAccess_Owner_OccGroup.cfm">
			   <cfelse>
			      <cfinclude template="UserAccess_Owner.cfm">
			   </cfif>		      
		  </cfcase>
		 
		  <cfcase value="OrderClass">
		   	   <cfinclude template="UserAccess_OrderClass.cfm">
		  </cfcase>
			 		  
		  <cfcase value="Entity">
		  	 	  
		  	 <cfif URL.ID1 neq "Object">
			   	  <table width="100%">
			      <cfif tree eq "1" and Role.GrantAllTrees eq "0">				  
				  
				       <!--- check if access was already granted --->
					  
					   <cfquery name="AccessGranted" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   SELECT   TOP 1 *
						   FROM     OrganizationAuthorization
						   WHERE    Mission     = '#url.mission#'
						   AND      Role        = '#Role.Role#'	
						   AND      UserAccount = '#get.account#'					   				
					   </cfquery>						  
					  
					  <cfset show = "0">
					  <tr id="i_#URL.mission#">
					  
					  <td colspan="4" align="center" style="padding:2px">					 
					  
						  <table width="80%" align="center" bgcolor="f4f4f4" style="border:1px solid silver;padding:3px">
							  <tr>
							  <cfif AccessGranted.recordcount gte "1">
								  <td width="70" align="center" class="labelmedium2" style="padding:2px" bgcolor="ffffaf" style="border-right:1px solid silver"><font color="6688aa">Has Prior</td>
								  <cfset cl = "regular">							  
							  <cfelse>							  		
								  <td width="70" style="padding:2px" bgcolor="white" style="border-right:1px solid silver"></td>
								  <cfset cl = "hide">
							  </cfif>
							  <td align="center" class="labelmedium2" style="padding:2px;cursor:pointer" onclick="showentity('#URL.mission#','#ms#','')">Click here to manage access</td>					 
							  </tr>
						  </table>		
						  			  
					  </td>
					  </tr>				
				   </cfif>	
				  				    
			 	  <cfinclude template="UserAccess_Entity.cfm">	
				  <tr><td height="4"></td></tr>			  				  
				  </table>
			 <cfelse>
			
				  <cfinclude template="UserAccess_Object.cfm">
			 </cfif>
			  
		  </cfcase>
		  
		  <cfcase value="ItemCategory">
			   	  <cfinclude template="UserAccess_ItemCategory.cfm">
		  </cfcase>		  		  
		  
		  <cfcase value="Indicator">
			   	  <cfinclude template="UserAccess_Indicator.cfm">
			  </cfcase>
		  
		  <cfdefaultcase>
		      <cfif Role.ParameterTable neq "">			  
			
			      <cfinclude template="UserAccess_ParameterTable.cfm">
				  
			  <cfelse>			  			 
			  	<cfinclude template="UserAccess_Default.cfm">				
			  </cfif>
		      
           </cfdefaultcase>
		
	</cfswitch>

</cfoutput>