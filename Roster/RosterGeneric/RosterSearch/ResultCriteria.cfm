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

<cf_screentop height="100%" scroll="No" html="No">

<cfquery name="Search" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *
	 FROM RosterSearch
	 WHERE SearchId = '#URL.ID#'	
</cfquery>	


<cfquery name="Criteria" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *
	 FROM RosterSearchLine A, Ref_SearchClass C
	 WHERE SearchId = '#URL.ID#'
	 AND A.SearchClass = C.SearchClass
	 ORDER BY ListingOrder, ListingGroup, A.SearchClass DESC, SelectDescription
</cfquery>	

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr><td height="10"></td></tr>
<TR class="linedotted">
  
    <TD width="15%" class="labelit">Criteria</TD>
    <TD width="25%" class="labelit">Element</TD>
    <TD width="50%" class="labelit">Search Selection</TD>
	<TD width="5%" class="labelit">&nbsp;</TD>
</TR>

<cfoutput query="Criteria" group="ListingOrder">
<cfset cnt = 1>

<CFOUTPUT group="SelectDescription">

<cfif selectdescription neq "" and selectdescription neq "ANY" and selectdescription neq "BOTH">

	<TR class="labelit linedotted navigation_row">
	   
	    <td colspan="1">
			<cfif cnt eq "1">
			<table cellspacing="0" cellpadding="0">
			<tr class="labelit"><td style="padding-left:3px">#ListingGroup#</b>
			    <cfif ListingGroupEdit eq "1">
				<a href="Search4.cfm?ID=#URL.ID#" target="main" class="clsNoPrint"><font color="0080FF">[edit]</font></a>
				</cfif>
				</td>
			</tr>
			</table>
			<cfset cnt = 0>
			</cfif>
		</td>
	    <td>#Description#
			<cfif SelectDateEffective neq "">
				from #Dateformat(SelectDateEffective, CLIENT.DateFormatShow)#  
			</cfif>	
			<cfif SelectDateExpiration neq "">
				until #Dateformat(SelectDateExpiration, CLIENT.DateFormatShow)#
			</cfif>	
		
		</td>
	    <TD width="60%">
		
		<cfif description eq "Roster Status">
		
		    	<cfquery name="Status" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_StatusCode
					WHERE  Owner  = '#Search.Owner#'
					AND    Id     = 'FUN' 
					AND    Status = '#selectid#'
				</cfquery>	
				
				<cfloop query="Status">
				#Meaning# (#status#)
				<cfif currentrow lt recordcount><br></cfif>
				</cfloop>
				
		<cfelse>
			<cfif SelectDescription eq "">ANY<cfelse>#SelectDescription#</cfif>
		</cfif>	
		
		</TD>
		<TD><cfif SelectParameter eq "">
		                    <cfelseif SelectParameter eq "0">No<cfelse>Yes</cfif></TD>
	</TR>
	
</cfif>
</CFOUTPUT>

</CFOUTPUT>

</table>

<cfset ajaxonload("doHighlight")>

