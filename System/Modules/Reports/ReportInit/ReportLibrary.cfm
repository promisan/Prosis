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

<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="6"></td></tr>		
		<tr class="line"><td colspan="1" class="labelmedium2">Report Library Files</font></td></tr>
		
		<tr><td height="6"></td></tr>		

<tr><td>

<cfquery name="Line" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ReportControl
		WHERE  Controlid = '#URL.ControlId#' 
</cfquery>

<cfif Line.Operational eq "0">	
	
		<cf_filelibraryN
		    Mode="report"	
			DocumentHost="report"	    
			DocumentPath="#url.path#"
			SubDirectory="" 
			Filter=""
			LoadScript="No"
			Insert="yes"
			Remove="yes"
			width="99%"		
			AttachDialog="yes"
			align="left"
			border="1">	
			
				
<cfelse>
	
		<cf_filelibraryN
			Mode="report"	
			DocumentHost="report"	    	    	
			DocumentPath="#url.path#"
			SubDirectory="" 
			Filter=""
			LoadScript="No"
			Insert="no"
			Remove="no"
			reload="true"			
			width="99%"
			align="left"
			border="1">	
	
</cfif>	

</td></tr>
</table>

