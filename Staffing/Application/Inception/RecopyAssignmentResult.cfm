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
<cfquery name="Assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
		SELECT    CONVERT(VARCHAR(10),Created,126) as Created,count(*) as Records
		FROM      PersonAssignment
		WHERE     Source = '#URL.Mission#-#url.MandateNo#'	
		GROUP BY  CONVERT(VARCHAR(10),Created,126) 
		ORDER BY  CONVERT(VARCHAR(10),Created,126) 
</cfquery>

<cfquery name="Contract" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  	
	 SELECT CONVERT(VARCHAR(10),Created,126) as Created,count(*) as Records
	 FROM Employee.dbo.PersonContract
	 WHERE  Mission   = '#url.Mission#'
	 AND    MandateNo = '#url.MandateNo#'	
	 GROUP BY  CONVERT(VARCHAR(10),Created,126) 
	 ORDER BY  CONVERT(VARCHAR(10),Created,126) 	 
</cfquery>

<table><tr>
	
	<td valign="top">
	    
	<table width="270" cellspacing="0" cellpadding="0">
		
		<cfif Assignment.recordcount eq "0">
		<tr class="labelit" ><td style="padding:2px"><font color="FF0000">No assignments were carried over</font></td></tr>
		<cfelse>
		<tr class="labelit"><td bgcolor="e5e5e5" style="padding:2px" colspan="2" align="center"><font color="gray">Merged Assignments</td></tr>
		</cfif>
		
		<cfoutput query="assignment">
		<tr class="labelit">
		   <td style="padding:2px"><font color="gray">- #dateformat(created,CLIENT.DateFormatShow)#</td>
		   <td align="right" style="padding:2px;padding-left:3px"><font color="gray">#records#</td>
		</tr>   
		</cfoutput>
		
	</table>
	
	</td>
	
	<td valign="top">
	
	<table width="270" border="0" cellspacing="0" cellpadding="0">
		
		<cfif Contract.recordcount eq "0">
		<tr class="labelit"><td style="padding:2px"><font color="FF0000">No contracts were carried over</font></td></tr>
		<cfelse>
		<tr class="labelit"><td bgcolor="e5e5e5" style="padding:2px" colspan="2" align="center"><font color="gray">Merged Contracts</td></tr>
		</cfif>
		
		<cfoutput query="contract">
		<tr>
		   <td style="padding:2px"><font color="gray">- #dateformat(created,CLIENT.DateFormatShow)#</td>
		   <td align="right" style="padding:2px;padding-left:3px"><font color="gray">#records#</td>
		</tr>   
		</cfoutput>
		
	</table>
	
	</td>
</td>	

</table>  