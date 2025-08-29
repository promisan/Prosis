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
<cfparam name="Attributes.Context"   default="">
<cfparam name="Attributes.Id"        default="">
<cfparam name="Attributes.Declaimer" default="">

<cfquery name="qObject" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   O.* , R.EntityDescription, R.DocumentPathName
	 FROM     OrganizationObject O, Ref_Entity R
	 WHERE    ObjectId = '#Attributes.ObjectId#'
	 AND      O.EntityCode = R.EntityCode
	 AND     O.Operational  = 1
</cfquery>

<cfoutput>

	<table width="100%">
			   
		<tr><td height="10"></td></tr>	
				
		<tr>
		<td colspan="2" align="center">
		<img src="cid:logo" height="58" width="58" alt="" border="0">
		 </td>
		</tr>
				
		<tr>
		<td colspan="2" align="center">
		 <font face="Verdana" size="2" color="808080">
			 This #attributes.context# from #session.first# #session.last# is related to :<br><br> <font face="Verdana" size="4" color="black">#qObject.ObjectReference# #qObject.ObjectReference2#</font>.
		 </font>
		 </td>
		</tr>
		
		<tr><td height="10"></td></tr>
		
		<tr>			
			<td class="description" align="center">
			<font face="Verdana" size="3" color="808080">
			<a href="#SESSION.root#/ActionView.cfm?id=#qObject.Objectid#">Press here to open it</a>
			</font>
			</td>
		</tr>		
		
	</table>
	
	<cfmailparam file = "#session.root#/images/Logos/System/Support.png" contentid="logo" disposition="inline">

</cfoutput>

		