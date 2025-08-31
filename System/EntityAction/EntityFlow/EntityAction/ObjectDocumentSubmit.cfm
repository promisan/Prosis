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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.FieldName" default="">
<cfparam name="Form.DocumentTemplate" default="">
<cfparam name="Form.LogActionContent" default="0">
<cfparam name="Form.DocumentStringList" default="">
<cfparam name="Form.DocumentPassword" default="">

<cfif Form.DocumentMode eq "Embed">

<!---
	<cfif #FileExists("#SESSION.rootPath#\#Form.DocumentTemplate#")#>
		
		<cfelse>
		
			<script language="JavaScript">
			
			{
			
			frm  = parent.document.getElementById("idialog");
			he = 200;
			frm.height = he
			}
			
			</script>
		
			 <cf_message message = "You entered an invalid document path. Operation not allowed."
			  return = "back">
			  <cfabort>
	
	</cfif>
	--->
	
</cfif>	

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_EntityDocument
		  SET    Operational = '#Form.Operational#',
 		         DocumentDescription = '#Form.DocumentDescription#',
				 DocumentTemplate    = '#Form.DocumentTemplate#',
				 DocumentMode        = '#Form.DocumentMode#',
				 DocumentStringList  = '#Form.DocumentStringList#',
				 DocumentPassword    = '#Form.DocumentPassword#',
				 LogActionContent    = '#Form.LogActionContent#'
		  WHERE  DocumentCode = '#URL.ID2#'
		   AND   EntityCode = '#URL.EntityCode#'
	    	</cfquery>
			
		<script>
		 <cfoutput>
			 window.location = "ObjectDocument.cfm?EntityCode=#URL.EntityCode#&type=#URL.type#"
		 </cfoutput> 
		</script>		
		
		

<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_EntityDocument
		WHERE  DocumentCode = '#URL.ID2#'
		   AND   EntityCode = '#URL.EntityCode#'
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_EntityDocument
			         (EntityCode,
					 DocumentType,
					 DocumentCode,
					 DocumentDescription,
					 DocumentTemplate,
					 DocumentStringList,
					 DocumentPassword,
					 LogActionContent,
					 DocumentMode,
					 Operational,
					 Created)
			      VALUES ('#URL.EntityCode#',
				      '#URL.Type#',
				      '#Form.DocumentCode#',
					  '#Form.DocumentDescription#',
					  '#Form.DocumentTemplate#',
					  '#Form.DocumentStringList#',
					  '#Form.DocumentPassword#',
					  '#Form.LogActionContent#',
					  '#Form.DocumentMode#',
			      	  '#Form.Operational#',
					  getDate())
			</cfquery>
	</cfif>	
	
	<cfoutput>
	
	<script>
		 <cfoutput>
			 window.location = "ObjectDocument.cfm?EntityCode=#URL.EntityCode#&ID2=new&type=#URL.type#"
		 </cfoutput> 
	</script>	
	
	</cfoutput>
	   	
</cfif>