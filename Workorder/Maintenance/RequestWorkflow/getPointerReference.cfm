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