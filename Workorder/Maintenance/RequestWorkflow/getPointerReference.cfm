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
<cfquery name="getLookup" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM	Ref_Request
		WHERE	Code = '#URL.ID1#'
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<cfif trim(getLookup.templateApply) eq "RequestApplyService.cfm">

	<TR class="labelit">
		<TD width="27%">Input Domain Reference No *:</TD>
	    <TD colspan="3">
	  	   	<input type="radio" class="radiol" name="PointerReference" id="PointerReference" value="0">No
			<input type="radio" class="radiol" name="PointerReference" id="PointerReference" value="1" checked>Yes	
	    </TD>
	</TR>
	
	<TR class="labelit">
		<TD>Action Mode *:</TD>
	    <TD colspan="3">
	  	   	<input type="radio" class="radiol" name="IsAmendment" id="IsAmendment" value="0">Generates a NEW Service
			<input type="radio" class="radiol" name="IsAmendment" id="IsAmendment" value="1" checked>Amends an existing Service line
	    </TD>
	</TR>

<cfelse>
	
	<input type="Hidden" class="radiol" name="PointerReference" id="PointerReference" value="0">
	<input type="Hidden" class="radiol" name="IsAmendment" id="IsAmendment" value="1">
	<TR class="labelit">
		<TD width="27%">Input Domain Reference No *:</TD>
	    <TD colspan="3">
	  	   	No
	    </TD>
	</TR>
	
	<TR class="labelit">
		<TD>Action Mode *:</TD>
	    <TD colspan="3">
			Amends an existing Service line
	    </TD>
	</TR>
	
</cfif>

</table>