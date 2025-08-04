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
<cfoutput>

<table width="97%" align="center" cellspacing="0" cellpadding="0">
	<tr><td height="6"></td></tr> 
	
	<tr>
	<td width="30%">Send a custom EMail</td>
	</tr>
	<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;once this action becomes DUE:</td>
	<TD>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td width="30">
		<cfif #GetAction.PersonMailCode# neq "">Yes
			</td>
			<td>					
			<cfif GetAction.PersonMailCode neq "">

				<cfquery name="ActionMail" 
					dbtype="query">
					SELECT *
					FROM Mail
					Where DocumentCode = '#GetAction.PersonMailCode#'
					</cfquery>				
		
				 #ActionMail.DocumentDescription#
								 
			</cfif>
					
		<cfelse>
			No
		</cfif>
					
		</td>
		</tr>
	</table>
   </td>
	</tr>
						
	<tr>
	<td>Send a custom EMail</td>
	</tr>
	<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;once this action is PROCESSED:</td>
	<TD>												
	<table cellspacing="0" cellpadding="0">					
		<tr>						
		<td width="40">
		<cfif GetAction.PersonMailAction neq "">Yes
			</td>
							
			<cfquery name="ActionMail" 
				dbtype="query">
				SELECT *
				FROM Mail
				Where DocumentCode = '#GetAction.PersonMailAction#'
				</cfquery>				

			<TD>
			 #ActionMail.DocumentDescription#
			 
		<cfelse>
			No
		</cfif>							
		</td>							
		</tr>													
	</table>						
	</td>
	</tr>
				
	<cfif GetAction.PersonMailAction neq "">				
		<tr valign="top">
		<td align="left">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/join.gif" align="absmiddle"	alt="" border="0">
			Attach "for this step" generated Documents:
		</td>									
		<td>
			<cfif GetAction.PersonMailActionAttach eq "1">Yes<cfelse>No</cfif>
		</td>
		</tr>	
		<tr valign="top">
		<td align="left">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/join.gif" align="absmiddle"	alt="" border="0">
			Attach "prior document" generated Documents:
		</td>									
		<td>
			<cfif GetAction.PersonMailActionAttachPrior eq "1">Yes<cfelse>No</cfif>
		</td>
		</tr>	
	</cfif>			
</table>
		
</cfoutput>		
	