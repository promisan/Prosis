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
<cf_tl id = "Warehouse is in use. Operation aborted."                    var="msg3">

    <cfquery name="CountRec" 
     datasource="appsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT    *
	     FROM      ItemWarehouse
	     WHERE     Warehouse  = '#url.id1#'
	</cfquery>

    <cfif CountRec.recordCount gt 0>
		 <cfoutput>
	     <script language="JavaScript">
	         alert("#msg3#")
	      </script>
		  </cfoutput>  
	 	 
    <cfelse>
		
		<cfquery name="Delete" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Warehouse 
				WHERE  Warehouse  = '#url.id1#'
	    </cfquery>
		
		<script language="JavaScript">   
		     parent.window.close();
			 opener.history.go();      
		</script>
		
		<!----
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	     action="Delete">--->
			
		
    </cfif>	
