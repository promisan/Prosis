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

<cfquery name="Criteria" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     PersonSearchLine A, Ref_SearchClass C
	 WHERE    SearchId = '#URL.ID#'
	 AND      A.SearchClass = C.SearchClass
	 ORDER BY ListingOrder, ListingGroup
</cfquery>	

<br>

<table width="75%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr>
    <td colspan="2" class="labelmedium" style="font-size:25px;height:55px">
	  <cf_tl id="Employee search criteria">
	</td>
	
</tr> 	
   
<tr><td colspan="2">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<TR class="labelmedium line">
		    <td width="5%"></td>
		    <TD width="20%"><cf_tl id="Group"></TD>
		    <TD width="35%"><cf_tl id="Aspect"></TD>
		    <TD width="35%"><cf_tl id="Selected"></TD>
			<TD width="5%"></TD>
		</TR>
		
		<cfoutput query="Criteria" group="ListingOrder">
			
			<TR class="line"><td></td><td colspan="3" class="labelit">#ListingGroup#</b></td></TR>
				
				<CFOUTPUT>
				
				<TR class="labelmedium" style="height:20px">
				    <td colspan="2"></td>
				    <TD class="regular">#Description#</TD>
				    <TD class="regular">#SelectDescription#</TD>
					
				</TR>
				
				</CFOUTPUT>
		
		</CFOUTPUT>
	
	</table>

 </td></tr>

</table>	
