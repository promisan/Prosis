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

<cfif Form.action eq "new">

		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  INSERT INTO Ref_SettlementMission
		         (Code,
			      Mission,
      			  GLAccount,
      			  ListingOrder,
      			  OfficerUserId,
      			  OfficerLastName,
      			  OfficerFirstName,
      			  Created)
		  VALUES ('#Form.Code#',
		          '#Form.Mission#', 
				  '#Form.GLAccount#',
				  '#Form.ListingOrder#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
		</cfquery>

<cfelseif Form.action eq "update">

		<cfquery name="Update" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  UPDATE Ref_SettlementMission
		  SET	 Mission  = '#Form.Mission#',
		  		 GLAccount= '#Form.GLAccount#',
				 ListingOrder='#Form.ListingOrder#'
		  WHERE  Code = '#Form.Code#'
		  AND    Mission = '#Form.MissionOld#'
		</cfquery>


</cfif>

<cfset url.code = Form.code>
<cfinclude template="List.cfm">
