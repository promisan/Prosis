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

<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.DocumentItem"       default="">
<cfparam name="Form.DocumentItemName"   default="">
<cfparam name="Form.ListingOrder"       default="">
<cfparam name="Form.DocumentPassword"   default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_EntityDocumentItem
		  SET    Operational         = '#Form.Operational#',
 		         DocumentItemName    = '#Form.DocumentItemName#',
				 ListingOrder        = '#Form.ListingOrder#'
		  WHERE  DocumentItem  = '#URL.ID2#'
		   AND   DocumentId = '#URL.DocumentId#' 
	</cfquery>
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityDocumentItem
		 WHERE  DocumentItem  = '#Form.DocumentItem#'
		   AND   DocumentId = '#URL.DocumentId#' 
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityDocumentItem
			         (DocumentId,
					 DocumentItem,
					 DocumentItemName,
					 ListingOrder,
					 Operational,
					 Created)
			      VALUES ('#URL.DocumentId#',
				      '#Form.DocumentItem#',
					  '#Form.DocumentItemName#',
					  '#Form.ListingOrder#',
			      	  '#Form.Operational#',
					  getDate())
			</cfquery>
	</cfif>		
		   	
</cfif>

<cfoutput>
<script>
	ptoken.location('../../EntityObject/ElementList/ObjectList.cfm?id2=new&DocumentId=#URL.DocumentId#')
</script>			
</cfoutput>

