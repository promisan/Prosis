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
<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT 	*
FROM  	#client.lanPrefix#Status
ORDER BY Class, StatusClass, Status
</cfquery>



<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Order Type">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
<cfoutput>
 
<script>

function recordedit(id1,id2){
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&ID2=" + id2, "EditStatus", "left=80, top=80, width= 600, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td height="4"></td></tr>

<tr><td colspan="2">

<cf_divscroll>

<table width="94%" align="center" class="navigation_table">

<tr class="line fixrow labelmedium2">
    <TD width="5%">&nbsp;</TD>
	<TD>Status</TD>
	<TD>Description</TD>
	<TD>Label</TD>
	<TD>Role</TD>
    <TD>Entered</TD>
</TR>


<cfoutput query="SearchResult" group="Class">
	<tr class="labelmedium2"><td height="25" colspan="6" style="font-size:18px; font-weight:bold;">#Class#</td></tr>

	<cfoutput group="StatusClass">
		<tr class="labelmedium2 line"><td height="25" style="font-size:15px" colspan="6">#StatusClass#</td></tr>		
		<cfoutput>
		    <TR class="labelmedium2 line"> 
				<TD style="padding-top:1px;" align="center">
					 <cf_img icon="open" onclick="recordedit('#StatusClass#', '#Status#')">
				</TD>			
				<TD>#Status#</TD>
				<TD>#StatusDescription#</TD>
				<TD>#Description#</TD>
				<TD>#Role#</TD>
				<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>			
		</cfoutput>
		<tr><td height="5"></td></tr>
	</cfoutput>
	<tr><td height="5"></td></tr>
</CFOUTPUT>

</TABLE>

</cf_divscroll>

</td>

</TABLE>


