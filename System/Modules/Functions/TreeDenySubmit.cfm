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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cftransaction action="BEGIN">

<cfif #URL.ID1# eq "">

	<cfquery name="Insert" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO Ref_ModuleControlDeny 
	         (SystemFunctionId,
			 Mission,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	      VALUES ('#URL.ID#',
	      	  '#Form.Mission#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
	</cfquery>
		
</cfif>

</cftransaction>
  	
<script>
	 <cfoutput>
	 #ajaxLink('#session.root#/System/Modules/Functions/TreeDeny.cfm?ID=#URL.ID#')#
	 </cfoutput> 
</script>	
   
