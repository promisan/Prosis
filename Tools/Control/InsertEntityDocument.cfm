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

<cfparam name="Attributes.documentstringlist" default="">

<!--- check role --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_EntityDocument
WHERE EntityCode   = '#Attributes.code#'
AND   DocumentType = '#Attributes.documenttype#'
AND   DocumentCode = '#Attributes.documentcode#'
</cfquery>

<cfif Check.recordcount eq "0">

    <cfquery name="InsertClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityDocument
	       (EntityCode, 
		    DocumentType, 
			DocumentCode, 
			DocumentDescription, 
			DocumentTemplate, 
			DocumentMode,
			DocumentStringList,
			OfficerUserId,
			OfficerLastName,
			OfficerFirstName)
	VALUES ('#Attributes.code#',
	        '#Attributes.DocumentType#',
			'#Attributes.DocumentCode#',
			'#Attributes.DocumentDescription#',
			'#Attributes.DocumentTemplate#',
			'#Attributes.DocumentMode#',
			'#Attributes.DocumentStringList#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
	</cfquery>
				
<cfelse>

	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_EntityDocument
	    SET    DocumentDescription  = '#Attributes.DocumentDescription#',
			   DocumentStringList   = '#Attributes.DocumentStringList#', 
			   DocumentTemplate     = '#Attributes.DocumentTemplate#'  
	   	WHERE  EntityCode   		= '#Attributes.code#'
		AND    DocumentType 		= '#Attributes.documenttype#'
	    AND    DocumentCode 		= '#Attributes.documentcode#'   
		
	</cfquery>

</cfif>
