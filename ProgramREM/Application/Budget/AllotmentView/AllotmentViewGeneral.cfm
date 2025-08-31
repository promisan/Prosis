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
<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes">

<cfset client.edition = url.edition>

<!--- generate position reference for budget preparation --->

<cfinvoke component = "Service.Process.Program.Position"  
   method           = "CreatePosition" 
   EditionId        = "#url.edition#">	

<cf_dialogREMProgram> 
<cf_dialogOrganization>

<cfparam name="URL.UNIT" default="-">

<cfoutput>
		
	<script>	
		
		function search() {
		
		    if (window.event.keyCode == "13")
				{	document.getElementById("findlocate").click() }						
		
		}
	
		function reloadBudget(page) {   		  	
			    	  
		   vw  = document.getElementById("view").value	 
		   la  = document.getElementById("layout").value	 		  
		   fd  = document.getElementById("find").value    
		   se  = document.getElementById("filterselect").value 
		   or  = document.getElementById("orgunit").value 	
		   ed  = document.getElementById("editionselect").value   
		   fi  = document.getElementById("SystemFunctionId").value   	
		   parent.Prosis.busy('yes')		  
		   _cf_loadingtexthtml='';
		      
		   ptoken.navigate('#SESSION.root#/ProgramREM/Application/Budget/AllotmentView/AllotmentViewDetail.cfm?systemfunctionid='+fi+'&id=budget&find='+fd+'&filter='+se+'&ProgramGroup=#URL.ProgramGroup#&period=#URL.Period#&edition='+ed+'&unit=#url.unit#&mode=#URL.mode#&ID1='+or+'&page=' + page + '&view=' + vw + '&lay=' + la + '&mission=#URL.mission#','content');	   
		   
		}
	
	</script>	

</cfoutput>

<table width="100%" height="99.9%" border="0" cellspacing="0" cellpadding="0">
	
	
	<cfparam name="url.unit" default="ORG">
	
	<cfif url.mode eq "AOR">
	
		<tr><td height="100%" width="100%">
			<cfinclude template="../Listing/MissingOrganization.cfm">
		</td></tr>
		
	<cfelseif url.mode eq "REQ">	
	
		<tr><td height="100%" width="100%" id="request">		
			<cfinclude template="../Requirement/RequirementView.cfm">
		</td></tr>
	
	<cfelse>
		
		<tr><td id="menu" height="20">
			<cfinclude template="AllotmentViewMenu.cfm">
		</td></tr>
		
		<tr><td valign="top" height="100%" style="padding:6px">				
		    <cf_divscroll id="content">			
			<cfinclude template="AllotmentViewDetail.cfm">
			</cf_divscroll>
		</td></tr>
			
	</cfif>	

</table>

<script>
	parent.Prosis.busy('no')
</script>
