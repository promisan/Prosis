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
<cfif url.id1 eq ""> 
	
	<cfquery name="Verify" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntryClass
		WHERE Code  = '#Form.Code#' 
	</cfquery>

    <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
 
  		<cfelse>
    
		<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_EntryClass
		         (Code,
				 Description, 
				 ListingOrder,
				 CustomDialog,
				 RequisitionTemplate,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#', 
		          '#Form.Description#',
		          '#Form.ListingOrder#',			  
				  '#Form.CustomDialog#',
				  '#Form.RequisitionTemplate#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		  </cfquery>
			  
	</cfif>	 

	<script language="JavaScript">   
		window.close()
		opener.location.reload()
 	</script>

<cfelse>

	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_EntryClass
	SET   Description           = '#Form.Description#',
		  ListingOrder          = '#Form.ListingOrder#',
		  CustomDialog          = '#Form.CustomDialog#',
		  RequisitionTemplate   = '#Form.RequisitionTemplate#',
	      Code = '#Form.Code#'
	WHERE Code = '#Form.CodeOld#' 
	</cfquery>
	
	<cfoutput>
		<script language="JavaScript">   
		     ColdFusion.navigate('RecordEditForm.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#&id1=#url.id1#','contentbox1');
			 window.opener.ColdFusion.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#','divListing');
		</script> 
	</cfoutput>
	
</cfif>