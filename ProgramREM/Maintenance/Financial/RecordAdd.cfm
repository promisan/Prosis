<cfparam name="url.idmenu" default="">

<cf_screentop label="Add Financial Metric" 
              height="100%" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

	<tr><td height="7"></td></tr>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Code" value="" message="Please enter a code" required="Yes" size="5" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxl">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="ListingOrder" value="0" message="Please enter a valid number" validate="integer" required="Yes" size="1" maxlength="2" style="text-align:center;" class="regularxl">
    </TD>
	</TR>
	
	<tr>
	<td class="labelmedium">Categories enabled:</td>
	</tr>
	<tr>
		<td colspan="2" style="padding-left:20px">
							
			<cfquery name="Category"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT	C.*
					FROM   	Ref_ProgramCategory C
					WHERE  	C.Code = AreaCode
					OR 		C.Parent is null
					OR		ltrim(rtrim(C.Parent)) = ''
					ORDER BY C.ListingOrder
			</cfquery>
			
			<cfset cnt = 0>
			<table width="100%" cellspacing="0" cellpadding="0">
			<cfoutput query="Category">
				
				<cfset cnt = cnt+1>
				<cfif cnt eq "1"><tr></cfif>
				<td width="33%">
				<table cellspacing="0" cellpadding="0"><tr><td>
				<input class="radiol" type="checkbox" name="ProgramCategory" value="#Code#"> 
				</td>
				<td style="padding-left:3px" class="labelmedium">#Description#</td>
				</tr>
				</table>
				</td>
				<cfif cnt eq "3"></tr><cfset cnt=0></cfif>		
			</cfoutput>
			</table>
		
		</td>
	</tr>
	
	<tr><td height="3"></td></tr>
		
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2" align="center">
	
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Save ">
	
	</td>	
	
	</tr>
		
	</CFFORM>
	
</TABLE>


<cf_screenbottom layout="innerbox">