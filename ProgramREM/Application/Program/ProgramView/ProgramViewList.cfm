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

<!---language matters --->
		
<cf_tl id="No progress report" var="1">
<cfset tStarted = "#Lt_text#">

<cf_tl id="Not started" var="1">
<cfset tNotStarted = "#Lt_text#">

<cf_tl id="Cluster" var="1">
<cfset tCluster = "#Lt_text#">

<cf_tl id="View project" var="1">
 <cfset tInquiry = "#Lt_text#">

 <cf_tl id="Maintain" var="1">
 <cfset tMaintain = "#Lt_text#">
 
 <cf_tl id="Add Project" var="1">
 <cfset tAdd = "#Lt_text#">
 
 <cf_tl id="Add SubProject" var="1">
 <cfset tAdds = "#Lt_text#">

 <cf_tl id="Add" var="1">
 <cfset tAdd = "#Lt_text#">

 <cf_tl id="Costing" var="1">
 <cfset tCosting = "#Lt_text#">
 
 <cf_tl id="Progress" var="1">
 <cfset tProgress = "#Lt_text#">

 <cf_tl id="Indicator" var="1">
 <cfset tIndicator = "#Lt_text#">
 
 <cf_tl id="Edit" var="1">
 <cfset tEdit = "#Lt_text#">
 
 <cf_tl id="Project" var="1">
 <cfset tProject = "#Lt_text#">

 <cf_tl id="Component" var="1">
 <cfset tComponent = "#Lt_text#">
 
<cfoutput>
    
	<cfajaximport>
	  
	<script language="JavaScript">
		
	function detail(id) {
			 	  
   	    box  = document.getElementById("i"+id);
									 		 
		if (box.className == "hide") {
			url = "#SESSION.root#/ProgramREM/application/program/programview/ProgramViewDetail.cfm?period=#URL.Period#&ProgramCode="+id;		  
			ptoken.navigate(url,'d'+id) 
			box.className = "regular"		   		
		 } else {
			box.className  = "hide";
		 }					
					
	  }	
	  
	  function refreshdata(fld,id) {	              
			ptoken.navigate('#SESSION.root#/ProgramREM/Application/Program/ProgramView/ProgramViewListRefresh.cfm?programid='+id+'&col='+fld,fld+'_'+id)
		}	

	</script>  
</cfoutput>
	
<!--- Query returning search results --->
		
<table width="99%" class="navigation_table">
	
	<TR class="line labelmedium2 fixrow" style="height:25px">
	    <td height="20" width="50"></td>
		<td width="70"></td>
		<td><cf_tl id="Code"></td>
	    <td style="padding-left:30px"><cf_tl id="Name"></td>
		<td width="70"></td>	
		<td width="40%"></td>
	    <TD width="20%"><cf_tl id="Entered"></TD>
	    <td colspan="2" style="padding-right:5px"><cf_tl id="Date"></td>		
	</TR>
				
	<cfset prior = "0">
	<cfset value = "">
	<cfoutput query="ResultListing">
			<cfinclude template="ProgramViewListDetail.cfm"> 
	</cfoutput>

</table>

