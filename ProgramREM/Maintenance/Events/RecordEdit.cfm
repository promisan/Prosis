
<cfparam name="url.idmenu" default="">

<cf_screentop label="Maintain Event" 
              height="100%" 
			  layout="webapp" 
			  banner="yellow" 
			  scroll="yes" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ProgramEvent
	WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this event ?")) {
		return true 
	}	
	return false	
}	

</script>

<!--- edit form --->

<cf_divscroll>

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
    <tr><td height="6"></td></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <input type="text" name="Code" value="#get.Code#" size="2" maxlength="2" class="regularxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required=  "yes" size="40" 
	   maxlenght = "40" class= "regularxl">
    </TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" 
	   			name="ListingOrder" 
				value="#get.ListingOrder#" 
				message="please enter a valid number" 
				validate="integer" 
				style="text-align: center;" 
				required="yes" 
				size="1" 
				maxlength="2" 
				class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr>
		<td valign="top" style="padding-top:4px" class="labelmedium">Enabled to:</td>
		<td>
							
			<cfquery name="Mission"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT DISTINCT Mission
				FROM   Program
				WHERE  Mission IN (SELECT Mission FROM Ref_ParameterMission)
			</cfquery>
			
			<cfset cnt = 0>
			<table width="100%" cellspacing="0" cellpadding="0">
			<cfoutput query="Mission">
		
				<cfquery name="Check"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT Mission
						FROM   Ref_ProgramEventMission
						WHERE ProgramEvent = '#get.code#'
						AND   Mission = '#mission#'
				</cfquery>
				
				<cfset cnt = cnt+1>
				<cfif cnt eq "1"><tr></cfif>
				<td width="23">
				<input type="checkbox" name="Mission" value="#Mission#" <cfif check.recordcount eq "1">checked</cfif>>
				</td>
				<td>#Mission#</td>
				<cfif cnt eq "3"></tr><cfset cnt=0></cfif>		
			</cfoutput>
			</table>
		
		</td>
	</tr>
	
	<tr>
	<td class="labelit" valign="top" style="padding-top:4px">Categories enabled:</td>
		<td>
							
			<cfquery name="Category"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT	C.*,
							(SELECT Code FROM Ref_ProgramEventCategory WHERE ProgramEvent = '#get.code#' AND ProgramCategory = C.Code) as Selected
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
				<td width="23">
				<input type="checkbox" name="ProgramCategory" value="#Code#" <cfif Selected neq "">checked</cfif>>
				</td>
				<td class="labelit">#Description#</td>
				<cfif cnt eq "3"></tr><cfset cnt=0></cfif>		
			</cfoutput>
			</table>
		
		</td>
	</tr>
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" align="center">
		
	<input class="button10g" type="button" style="width:120;height:22" name="Cancel" value="Close" onClick="window.close()">
    <input class="button10g" type="submit" style="width:120;height:22" name="Delete" value="Delete" onclick="return ask()">
    <input class="button10g" type="submit" style="width:120;height:22" name="Update" value="Update">
	</td>	
	
	</CFFORM>
	
</TABLE>

</cf_divscroll>
	
<cf_screenbottom layout="innerbox">