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
<!--- validate enforce custom attachment to be 
provided which are explicityly enabled for this Step in the workflow (aka custom field --->

<cfquery name="Attachment" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
	SELECT   R.*
	FROM     Ref_EntityActionPublishDocument AS W 
	         INNER JOIN Ref_EntityDocument AS R ON W.DocumentId = R.DocumentId 
			 INNER JOIN Ref_EntityActionDocument R1 ON  R.DocumentId = R1.DocumentId AND R1.ActionCode = '#Action.ActionCode#'
	WHERE    W.ActionPublishNo = '#Object.ActionPublishNo#' 
	AND      W.ActionCode      = '#Action.ActionCode#' 
	AND      R.DocumentType    = 'Attach' 
	AND      R.DocumentMode    = 'Step'
	AND      R.FieldRequired   = '1'
	AND      R.Operational    = 1 
	AND      W.Operational = 1
	 
</cfquery>	 

<cfif form.actionstatus neq "1">
		
	<cfoutput query="Attachment">
	
		<!--- perform the validation --->
		
		<cfquery name="Check" 
		 datasource="AppsSystem"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	
			SELECT       *
			FROM         Attachment
			WHERE        Reference = '#Object.Objectid#' 
			AND          FileStatus <> '9' AND FileName LIKE '#DocumentCode#%'
			
		</cfquery>	
				
		<cfif check.recordcount eq "0">
			
			  <cf_message message = " <br>Please attach <span style='color:red;font-size:20px'>#DocumentDescription#</span> in order to continue" return="false">
			  <cfabort>
		
		</cfif>
		
	</cfoutput>

</cfif>
		