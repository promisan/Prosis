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

<cfparam name="Form.AssetId"  default="">
<cfparam name="Form.Memo"     default="">
	
<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsCaseFile" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE   ClaimAsset 
			  SET  Assetid = '#Form.AssetId#', 				 				 
				   Memo                 = '#Form.Memo#'		 
			 WHERE ClaimId= '#URL.ClaimId#' 
			 AND   Assetid = '#URL.ID2#'
	 </cfquery>
		
	 <cfset url.id2 = "">
	 <cfinclude template="Line.cfm">	
			
<cfelse>
		
	<cfquery name="Insert" 
	    datasource="AppsCaseFile" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	     INSERT INTO ClaimAsset 
		         (ClaimId,				 
				 AssetId,									
				 Memo,				
				 OfficerUserId,
				 OfficerLastname,
				 OfficerFirstName)
	      VALUES
			     ('#URL.claimid#',				
				  '#Form.AssetId#',				 
				  '#Form.Memo#',	
		      	  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
	</cfquery>
			
	<cfset url.id2 = "">
	<cfinclude template="Line.cfm">	
		   	
</cfif>