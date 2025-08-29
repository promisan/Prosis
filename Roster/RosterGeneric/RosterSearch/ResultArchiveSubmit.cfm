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
<cfquery name="Update" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE RosterSearch 
	 SET    Status      = '1', 
	        Description = '#Form.Description#', 
		    Access      = '#form.Access#'
	 WHERE  SearchId    = '#FORM.SearchId#'
</cfquery>
	 
<cfquery name="Search" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearch
		WHERE  SearchId = '#Form.SearchId#'
</cfquery>  

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 

<script language="JavaScript">	
   parent.window.location = "Search1.cfm?Status=#url.status#&DocNo=#url.docno#&Owner=#Search.Owner#&mode=#url.mode#&mid=#mid#";
</script>	

</cfoutput>  