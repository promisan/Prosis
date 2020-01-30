<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="No" 
			  layout="webapp" 
			  banner="gray"
			  label="Add Competence" 
			  menuAccess="Yes" 
			  user="no"
			  systemfunctionid="#url.idmenu#">

<CFFORM action="RecordSubmit.cfm" method="post"  enablecab="yes" name="dialog">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td style="height:5px"></td></tr>

   <!--- Field: Id --->
    <TR>
	    <TD class="labelmedium">Code:</TD>
	    <TD>
			<cfinput type="Text" name="CompetenceId" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"	class="regularxl">
		</TD>
	</TR>
	
	<!--- Field: Description --->
    <TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD>
			<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
		</TD>
	</TR>
		
    <TR>
	    <TD class="labelmedium">Order:</TD>
	    <TD>
	  	  	<cfinput type="Text" name="ListingOrder" value="0" message="Please enter a valid number" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl">				
	    </TD>
	</TR>
				
	<TR>
	    <TD class="labelmedium">Operational:</TD>
	    <TD class="labelmedium">
		    <INPUT type="radio" class="radiol" name="Operational" value="0">Disabled
			<INPUT type="radio" class="radiol" name="Operational" value="1" checked> Enabled
		</TD>
	</TR>
	
	<!--- Field: Description --->
    <TR>
	    <TD class="labelmedium">Category:</TD>
	    <TD>
		
			<cfquery name="Category" datasource="AppsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_CompetenceCategory
			</cfquery>
			
	 		<cfselect name="CompetenceCategory" class="regularxl" id="CompetenceCategory" message="Please select a category" required="Yes">
				<cfoutput query="Category">
					<option value="#Code#">#Description#</option>
				</cfoutput>
			</cfselect>
			
	    </TD>
	</TR>
	
	<tr><td colspan="3" height="1"></td></tr>
	<tr><td class="linedotted" colspan="2"></td></tr>
	<tr><td colspan="3" height="1"></td></tr>
	
	<tr>
		<td colspan="2" align="center">
			<input class="button10g" style="width:100px" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
			<input class="button10g" style="width:100px" type="submit" name="Insert" value=" Submit ">
		</td>	
	</tr>
    
</TABLE>

</CFFORM>

