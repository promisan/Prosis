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
<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderParameter.cfm"></td></tr>	 

<cfoutput>

<cfquery name="SearchResult"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   L.*, R.FunctionName
	FROM     PortalLinks L LEFT OUTER JOIN Ref_ModuleControl R
	ON       L.SystemFunctionId = R.SystemFunctionId	
	ORDER BY Class, FunctionName, ListingOrder
</cfquery>

<script>

function recordadd(grp) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=790, height=580, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=790, height=580, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
</cfoutput>
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">
	
	<tr  class="labelmedium2"><td style="padding-top:5px;font-size:16px;color:gray" colspan="7">Add external links to the ERP or selfservice portal for easy reference. Like the reference option below:</td></tr>
	
	<tr><td style="height:80px" align="center" colspan="7"><img src="Illustration.PNG" alt="" width="400" height="50" border="0"></td></tr>
	
	<tr class="line labelmedium2">   
	    <TD height="20">Class</TD>
		<td width="70">Language</td>
		<TD width="30%">Description</TD>
		<TD>Target</TD>
		<TD>Servers</TD>
		<TD align="center">Order</TD>
		<TD>Entered</TD>  
	</TR>
	
	<cfoutput query="SearchResult" group="Class">
	
	    <tr><td height="4"></td></tr>
	    <tr class="line">
	    <td colspan="7" class="labellarge" style="height:34;padding-left:10px"><cfif Class eq "Custom">Self Service Top Menu<cfelseif Class eq "CustomLeft">Self Service left menu<cfelse>#Class#</cfif></b></td>
	    </tr>
				
	<cfoutput group="FunctionName">
	
	 <cfif FunctionName neq "">
	
	    <tr class="line"><td colspan="5" style="font-size:25px" height="30" class="labellarge">#FunctionName#</b></td> </tr>
				
	 </cfif>
		
	<cfoutput>    
		
		<TR bgcolor="white" class="navigation_row line labelmedium2">
			<td width="5%" rowspan="2" style="padding-top:1px" align="center">		
				<cfset rec = "record">			
				<cf_img icon="edit" navigation="Yes" onclick="#rec#edit('#PortalId#')">						
										  
			</td>		
			<td rowspan="2"><cfif LanguageCode eq "">Any<cfelse>#LanguageCode#</cfif></td>
			<TD height="20" width="40%">#Description#</TD>	
			<TD>#LocationTarget#</TD>
			<td>#HostNameList#</td>
			<td align="center">#ListingOrder#</td>
			<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#&nbsp;</TD>		
	    </TR>
		
		<tr class="line navigation_row_child">
		 <td style="border-top:1px dotted silver; border-left:1px dotted silver;padding-left:3px" colspan="5" class="labelit">
		  <a href="#LocationURL#<cfif LocationString neq "">?#LocationString#</cfif>" target="_blank" title="Go to Link">
		  #LocationURL#<cfif LocationString neq "">?#LocationString#</cfif>
	    </a>
		</td>
		</tr>
				
	</CFOUTPUT>	
		
	</CFOUTPUT>	
	
	</CFOUTPUT>
	
	</TABLE>
	
	</cf_divscroll>

</td>
</tr>

</TABLE>
