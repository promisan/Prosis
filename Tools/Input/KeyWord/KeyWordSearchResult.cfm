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
<HTML><HEAD>
    <TITLE>Item search</TITLE>
   <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
   
</HEAD><body onLoad="window.focus()">
	
<cf_wait>	

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   DISTINCT R.*, 
         C.Description as Class
FROM     Ref_Experience R INNER JOIN
         Ref_ExperienceClass C ON R.ExperienceClass = C.ExperienceClass
WHERE    C.Parent = '#Form.Filter#' 
<cfif #Form.Class# neq "">
AND      C.ExperienceClass = '#Form.Class#'
</cfif>
AND       R.Description LIKE '%#Form.Experience#%'

</cfquery>
	
<CFOUTPUT>		

<script>

function selected(id)
{
        
		var form = "#Form.FormName#";
		var field1 = "#Form.ExperienceId#";
				
		ie = document.all?1:0
		
		if (ie)
		
		{
				
		self.returnValue = id;
		self.close();

		}
		
		else
		
		{
			
		var frm = "parent.opener.document."
		
		try { se = eval(frm + form + "." + field1); 
		      se.value = zip
			  parent.opener.key(id,'zipfind'); 
			}
		catch (se) {}
								
		parent.window.close()	
		}
		
}
</script>

</CFOUTPUT>

<div style="overflow: auto; height:430; scrollbar-face-color: F4f4f4;">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right">
  <tr>
   
   <td align="right">
    
		<table width="99%" border="0" cellspacing="0" cellpadding="0"frame="all">   
								
		<TR bgcolor="f4f4f4">
		    <td height="17"></td>
			
		    <td width="10%">Id</td>
		    <TD>Class</TD>
			<TD>Description</TD>
			
		</TR>
		
		<CFOUTPUT query="SearchResult">
				
		
		<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffcf'))#">
		<td width="60" height="20" align="center">
		<img src="#SESSION.root#/Images/pointer.gif" name="sel#currentrow#" 
		   onMouseOver="document.sel#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
		   onMouseOut="document.sel#currentrow#.src='#SESSION.root#/Images/pointer.gif'" 
		   style="cursor: pointer;" 
		   width="9"
		   height="9"
		   alt="Select" 
		   border="0" 
		   onClick="javascript:selected('#ExperienceFieldId#')">
		</td>
		<TD width="70"><a href="javascript:selected('#ExperienceFieldId#')">#ExperienceFieldId#</A></TD>
		<TD><a href="javascript:selected('#ExperienceFieldId#')">#Class#</a></TD>
		<TD>#Description#&nbsp;</TD>
		
		</TR>
		<tr><td height="1" colspan="4" bgcolor="EAEAEA"></td></tr>
				
		</CFOUTPUT>
		
		</table>
		
		</td>
		
		</tr>

</TABLE>
</div>

<cf_waitEnd>	


</BODY></HTML>