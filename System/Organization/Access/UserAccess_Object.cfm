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

 <!--- global roles --->
 <input type="hidden" name="class" id="class" value="1">
   
 <!--- create entity table --->
 
 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity">
 <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity1">
  
 <!--- define object steps --->
        	
  <cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *	
    FROM    OrganizationObject O
	WHERE   O.ObjectId = '#URL.ID2#'	
  </cfquery> 
       	
  <cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  DISTINCT R.EntityCode,
		        R.EntityDescription, 
		        O.EntityGroup, 
				O.Mission,
				O.OrgUnit,
				R.Role,
				E.ActionCode, 
				EP.ActionDescription,
				EP.ActionReference, 
				EP.ActionType,
				EP.ActionOrder
		INTO    userQuery.dbo.#SESSION.acc#Entity 
	    FROM    OrganizationObject O, 
				Ref_EntityActionPublish EP,
				Ref_EntityAction E,
				Ref_Entity R
		WHERE   O.ObjectId = '#URL.ID2#'
		AND     O.ActionPublishNo = EP.ActionPublishNo
		AND     EP.ActionCode = E.ActionCode
		AND     R.EntityCode = O.EntityCode 
		AND     E.EnableAccessFly = 1
		AND     O.Operational  = 1
		ORDER BY EP.ActionOrder 
  </cfquery>      
  
  <cfsavecontent variable="user">    
	<cfoutput>
	SELECT    A.*	
	FROM      Organization.dbo.OrganizationAuthorization A
    WHERE     A.UserAccount = '#URL.ACC#' 
	AND       A.ClassIsAction = 1	
    </cfoutput>   
  </cfsavecontent>
    
  <cfquery name="EntityAccessGranted" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT    DISTINCT E.*, 
	          CASE WHEN A.AccessId is NULL THEN 0 ELSE 1 END AS Granted	
	INTO      userQuery.dbo.#SESSION.acc#Entity1 		  
	FROM      userQuery.dbo.#SESSION.acc#Entity  E LEFT OUTER JOIN
		      (#preservesingleQuotes(user)#) as A ON E.ActionCode = A.ClassParameter 
			  AND E.EntityGroup = A.GroupParameter 
			  AND E.Role = A.Role 
			  <cfif Object.Mission neq "">
			  AND E.Mission = A.Mission
			  </cfif>					  
			  <cfif Object.OrgUnit neq "">
			  AND E.OrgUnit = A.OrgUnit
			  </cfif>			 
  </cfquery> 	
  	
  <cfquery name="AccessList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     E.*,
	           A.AccessLevel, 
			   '0' as RecordStatus, 
			   1 as number 
    FROM       OrganizationObjectActionAccess A RIGHT OUTER JOIN 
			   userQuery.dbo.#SESSION.acc#Entity1 E ON A.ActionCode  = E.ActionCode				   
	    AND    A.ObjectId    = '#URL.ID2#'
		AND    A.UserAccount = '#URL.Acc#'	
	ORDER BY   E.ActionOrder
  </cfquery>
    
  <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity">	
  <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Entity1">   
  	
	<table width="100%" class="navigation_table">
	
	<cfoutput query="AccessList" group="EntityCode">
	
	<tr class="labelmedium fixrow"><td colspan="5" style="height:30px;background-color:white;font-size:19px;padding-left:4px"><font size="2">Object:</font> <b>#EntityDescription#</td></tr>
	
		<cfoutput>
		<input type="hidden" name="#ms#_classparameter_#CurrentRow#" id="#ms#_classparameter_#CurrentRow#" value="#ActionCode#">
		<input type="hidden" name="#ms#_groupparameter_#CurrentRow#" id="#ms#_groupparameter_#CurrentRow#" value="#EntityGroup#">
			
		<tr class="Linedotted labelit navigation_row">	
		 <td class="fixlength" style="font-size:13px;padding-left:8px;"><cfif ActionReference neq ""><b>#ActionReference#</b>:</cfif>#ActionDescription# </td>
		 <td>#ActionType#</td>
	     <td>#ActionCode#</td> 
		 <td width="30%" align="center" class="labelit">
		      <cfset accesslvl = AccessLevel>
		      <cfif Granted eq "0">
				  <cfinclude template="UserAccessSelectAction.cfm">
			  <cfelse>
			  
			        <cfparam name="cnt"        default="1">
			        <cfparam name="row"        default="1">
					 			  				   
				    <input type="hidden" name="#ms#_AccessLevel_old_#CurrentRow#" id="#ms#_AccessLevel_old_#CurrentRow#" value="#AccessLvl#">     
				     
				    <table>					
					<tr class="labelmedium2">
					
					<td style="border:1px solid gray;width:30px;background-color:80FF00;padding-bottom:2px;border-right:0px" title="role access granted">
					<input type  = "radio" 
					   name      = "#ms#_AccessLevel_#CurrentRow#" 
					   id        = "g#url.mission##row#_#cnt#"
					   value     = "" 			    
					   <cfif AccessLvl eq "">checked</cfif>
					   onClick   = "ClearRow('d#ms#_#CurrentRow#','')">
				
					<td style="border:1px solid gray;width:30px;background-color:80FF00;border-left:0px;padding-right:10px"> <cf_tl id="Granted"></td>		
				
					<td style="padding-left:5px;border:1px solid gray;width:26px;background-color:FF8080;padding-bottom:2px;" title="Explicitly deny access, regardless if role access exists">
			      
		    		<input type  = "radio" 
					   name      = "#ms#_AccessLevel_#CurrentRow#" 
					   id        = "g#url.mission##row#_#cnt#"
					   value     = "9" 			    
					   <cfif AccessLvl eq "9">checked</cfif>
					   onClick   = "ClearRow('d#ms#_#CurrentRow#','9')">
						
					 </td>					 
					 </tr>
					 
					 </table>  
	  
			   </td>
		  			  
			  </cfif>
		  </td>
		</tr>	
		</cfoutput>
	</cfoutput>
    </table>
		
	<cfset class = AccessList.recordcount>
	
	<cfset ajaxonload("doHighlight")>
	
