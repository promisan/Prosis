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

<!--- add funinction --->

<cfparam name="url.action"     default="">
<cfparam name="url.id1"        default="">
<cfparam name="url.functionno" default="">

<cfif url.action eq "add">

	<cfquery name="check" 
      datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	   SELECT     *
       FROM       MissionProfileFunction 
       WHERE      ProfileId = '#url.id1#' and FunctionNo = '#url.functionno#'
    </cfquery>
	
	<cfif check.recordcount eq "0">
	        
		<cfquery name="Insert" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO MissionProfileFunction
				(ProfileId, FunctionNo,OfficerUserId,OfficerLastName,OfficerFirstName) 
				
			VALUES (
				'#url.id1#', 
				'#url.functionno#', 		
				'#SESSION.acc#',
			    '#SESSION.last#',		  
				'#SESSION.first#')
			
		</cfquery>
	
	</cfif>
	
<cfelseif url.action eq "delete">	

	<cfquery name="check" 
      datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	   DELETE FROM MissionProfileFunction 
       WHERE       ProfileId = '#url.id1#' 
	   AND         FunctionNo = '#url.functionno#'	   
    </cfquery>
	
</cfif>	

<cfquery name="getFunction" 
   datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     FT.FunctionNo, FT.FunctionDescription, MPF.OfficerUserId, MPF.Created
    FROM       MissionProfileFunction AS MPF INNER JOIN
               Applicant.dbo.FunctionTitle AS FT ON MPF.FunctionNo = FT.FunctionNo
    WHERE      ProfileId = '#url.id1#'
</cfquery>

<table style="width:100%">
    <cfif getFunction.recordcount eq "0">
		<tr><td><cf_tl id="No records founds"></td></tr>	 
	</cfif>
	 
	<cfoutput query="getFunction">
	<tr class="labelmedium2 linedotted" style="height:10px">
	     <td><cf_img icon="delete" onclick="javascript:deletefunction('#functionno#')"></td>
	     <td>#FunctionDescription#</td>
	     <td>#OfficeruserId#</td>
		 <td>#dateformat(created,client.dateformatshow)#</td>		
	 </tr>
	</cfoutput>
	
</table> 

			