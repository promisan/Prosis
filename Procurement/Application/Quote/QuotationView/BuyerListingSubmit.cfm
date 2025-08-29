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
<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cfquery name="Member" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * FROM JobActor
	  WHERE JobNo  =  '#url.jobno#'
	  AND ActorUserId = '#URL.acc#'
	  AND Role = 'ProcBuyer' 
	</cfquery>
	
	<cfif Member.recordcount eq "0">
	
		<cfquery name="user" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT * FROM UserNames
		  WHERE Account = '#url.acc#'
		</cfquery>

		<cfquery name="Employee" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO JobActor
		    (JobNo,
			 ActorUserId,
			 Role,
			 ActorLastName,
			 ActorFirstName,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
		VALUES(	
			'#URL.JobNo#',
			'#URL.acc#',
			'ProcBuyer',
			'#user.LastName#',
			'#user.firstName#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#') 
		</cfquery>
	
	</cfif>
	
<cfelseif url.action eq "delete">	

	<cfquery name="Employee" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 DELETE FROM JobActor
	  WHERE JobNo  =  '#url.jobno#'
	  AND ActorUserId = '#URL.acc#'
	  AND Role = 'ProcBuyer' 
	</cfquery>
	
</cfif>

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     JobActor
	WHERE    JobNo = '#URL.JobNo#' 
	AND      Role = 'ProcBuyer'
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
		<cfif searchresult.recordcount eq "0">
			<tr><td align="center"><font color="FF0000"><cf_tl id="No buyer"></font></td></tr>		
		
		<cfelse>
				
		<tr> 
		    <td align="center" width="17"></td>
		    <TD width="100" class="labelit"><cf_tl id="Account"></TD>
			<TD width="40%" class="labelit"><cf_tl id="Buyer Name"></TD>
			<TD width="30%" class="labelit"><cf_tl id="Granted By"></TD>
			<TD width="10%" class="labelit"><cf_tl id="Added"></TD>
			<TD width="3%"></TD>
		</TR>
		
		</cfif>
		
		<cfoutput query="SearchResult">
			<TR bgcolor="white"><td height="1" colspan="6" class="linedotted"></td></tr>
			
			<TD align="center" width="4%" class="labelsmall">#currentRow#.</TD>
			<td class="labelit">#ActorUserId#</td>
			<TD class="labelit">#ActorFirstName#, #ActorLastName#</TD>		
			<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>			
			<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
			<TD height="20" style="padding-top:2px">
			<cfif searchresult.recordcount gte "2">
			    <cf_img icon="delete" onClick="javascript:ColdFusion.navigate('BuyerListingSubmit.cfm?action=delete&jobno=#URL.jobno#&acc=#ActorUserId#','buyerbox')">				
			</cfif>	
			</TD>			
		    </TR>
			
		</CFoutput>	
		
	</table>
	
   