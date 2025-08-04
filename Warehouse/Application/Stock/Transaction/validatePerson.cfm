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

<!--- validate --->

 <cfquery name="get" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Person 
	 WHERE  PersonNo = '#url.personno#'
</cfquery>

<cfoutput>

<cfif get.recordcount eq "0" or url.value eq "">

	<script>			   
		 document.getElementById('personselect').value = ""
		 document.getElementById('personidselect').value = ""		 
		 ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getPerson.cfm?mission=#url.mission#&personno=','personbox')
	</script>
	
<cfelse>

    <script>		
		 _cf_loadingtexthtml='';	
	     document.getElementById('personselect').value = "<cfif get.Reference neq "">#get.Reference#<cfelse>#get.IndexNo#</cfif>"
		 ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getPerson.cfm?mission=#url.mission#&personno=#get.personno#','personbox')
	</script>		

</cfif>	 

</cfoutput>