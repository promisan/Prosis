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
<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM  Ref_Nation
  ORDER BY Continent
</cfquery>

<cfset Page = "0">
<cfset Header = "Nations">

<table style="height:100%;width:96%" align="center">
<tr><td>
<cfinclude template="../HeaderParameter.cfm"> 
</td></tr>

<cfoutput> 

<script>

function reloadForm(page){
	ptoken.location="RecordListing.cfm?Page=" + page; 
}

function recordadd(grp){
    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td style="height:100%">

<cf_divscroll>
	
	<table width="96%" align="center">
	
	<tr class="line fixrow labelmedium2">
	    <TD align="center">Area</TD>
	    <TD>Code</TD>
		<TD>Name</TD>
		<td></td>
	    <TD>Code</TD>
		<TD>Name</TD>
		<td></td>
		<TD>Code</TD>
		<TD>Name</TD>
		
	</TR>
	
	<cfoutput query="SearchResult" group="Continent">
	
	<cfif continent neq "">
	<tr class="fixrow2"><td colspan="7" class="labelmedium line" style="font-size:23px;padding-left:4px;height:45">#Continent#</font></td></tr>
	</cfif>
	
	<cfset cnt  = "0">
	
	<cfoutput>
	   
	    <cfset cnt = cnt+1>
	    <cfif cnt eq "1">
		<TR class="labelmedium2 line">
		</cfif>
		
	    <td align="center" style="height:16px;padding-top:1px">
		  <cf_img icon="open" onclick="recordedit('#Code#')">	 
		</td>		
		<TD style="padding-left:2px">#Code#</TD>
		<TD style="padding-left:2px">#name#</TD>	
		<cfif cnt eq "3">
	    </TR>		
		<cfset cnt = 0>
		</cfif>
		
	</CFOUTPUT>
	
	</cfoutput>
	
	</TABLE>

</cf_divscroll>

</td></tr>
</table>

