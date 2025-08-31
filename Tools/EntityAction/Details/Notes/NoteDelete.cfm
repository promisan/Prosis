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
<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM   OrganizationObjectActionMail
		WHERE  ObjectId  = '#URL.ObjectId#'
		AND    ThreadId   = '#URL.ThreadId#'
		AND    SerialNo   >= '#URL.SerialNo#' 			
</cfquery>

<cfquery name="Delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   OrganizationObjectActionMail
		WHERE  ObjectId  = '#URL.ObjectId#'
		AND    ThreadId   = '#URL.ThreadId#'
		AND    SerialNo   >= '#URL.SerialNo#' 			
</cfquery>


<cfoutput>

<cfif url.mode eq "actor">

     <!--- insight portal mode --->
	
	 <script>
	   
		 window.dialogArguments.opener.listcontent('#url.Objectid#')
		 window.close()
	 </script>
		
<cfelse>
	
	 <script>	
	    try {	      
		parent.opener.ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/notes/NoteList.cfm?box=#url.box#&mode=note&objectid=#url.ObjectId#&actioncode=#url.ActionCode#','#url.box#')		
		} catch(e) {}
		window.close()
	 </script>

</cfif>	

</cfoutput>



	
