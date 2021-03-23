
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="yellow" 
			  label="Edit Classification" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Group
WHERE GroupCode = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Position Group?")) {	
	return true 	
	}	
	return false	
}	

function hl(act){
   	 	 
	 sel = document.getElementById("ShowInColor")
	 	 
	 if (act == "hide")
	 { sel.className = "Hide" ; 
	   sel.value = ""}
	 else
	 { sel.className = "regular" ; }
		
  }
 

</script>

<cf_divscroll>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <cfoutput>
	<tr><td height="5"></td></tr>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="regular">
	  <table width="100%" cellspacing="0" cellpadding="0">
	   <tr><td>
  	   <input type="text" name="GroupCode" value="#get.GroupCode#" size="10" maxlength="10"class="regularxl">
	   <input type="hidden" name="GroupCodeOld" value="#get.GroupCode#" size="10" maxlength="10" readonly>
	   </td>
	   <TD align="right" class="labelmedium">Enabled:
  	   <input type="checkbox" name="Operational" value="1" <cfif get.Operational eq "1">checked</cfif>>
	   </TD>
	   </tr>
	   </table>
    </TD>
	</TR>
			
	<tr><td height="1"></td></tr>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="40"class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="1"></td></tr>
	
	<TR>
    <TD class="labelmedium">Context:</TD>
    <TD>
	   <select name="GroupDomain" class="regularxl">
					<option value="Position" <cfif get.GroupDomain eq "Position">selected</cfif>>Position</option>
					<option value="Assignment" <cfif get.GroupDomain eq "Assignment">selected</cfif>>Assignment</option>
		</select>
     </TD>
	</TR>
		
	<tr><td height="1"></td></tr>
	
	<TR>
    <TD class="labelmedium">Show in Tree: </TD>
    <TD class="labelmedium" height="23">
	   <input type="radio" name="ShowInView" value="0" <cfif get.ShowInView eq "0">checked</cfif> onClick="hl('hide')">No
	   <input type="radio" name="ShowInView" value="1" <cfif get.ShowInView eq "1">checked</cfif> onClick="hl('show')">Yes
	   &nbsp;
	   <input class="regularxl" type="text" style="text-align:center" class="<cfif #get.ShowInView# eq "1">text<cfelse>hide</cfif>" name="ShowInColor" value="#get.ShowInColor#" size="6" maxlength="10">
   	  (applies to Context [Position]) 
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr>
		<td colspan="2" style="padding-top:2px;padding-left:30px">
							
			<cfquery name="Mission"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT    Mission,
							(SELECT MissionOwner 
							 FROM Organization.dbo.Ref_Mission 
							 WHERE Mission = M.Mission) as Owner
				FROM   	  Ref_ParameterMission M
				WHERE     Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1)
				ORDER BY  Owner
			</cfquery>
						
			<table width="100%" cellspacing="0" cellpadding="0" class="formspacing">
			
			<cfoutput query="Mission" group="owner">
			
				<tr><td colspan="3" style="height:30px" class="labellarge"><cfif owner eq "">Undefined<cfelse>#owner#</cfif></b></td></tr>
				<tr><td class="linedotted" colspan="4"></td></tr>				
				<cfset cnt = 0>
				<cfoutput>
					<cfquery name="Check"
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT 	Mission
							FROM   	Ref_GroupMission
							WHERE 	GroupCode = '#get.GroupCode#'
							AND   	Mission = '#mission#'
					</cfquery>
					
					<cfset cnt = cnt+1>
					<cfif cnt eq "1"><tr></cfif>
					<td class="labelmedium">
					<label>
						<input type="checkbox" name="Mission" value="#Mission#" <cfif check.recordcount eq "1">checked</cfif>>
						#Mission#
					</label>
					</td>
					<cfif cnt eq "3"></tr><cfset cnt=0></cfif>
				</cfoutput>
									
			</cfoutput>
			</table>
		
		</td>
	</tr>
	<cfoutput>
	<tr><td height="6" colspan="2"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td height="6" colspan="2"></td></tr>
	<TR>
		<td colspan="2" align="Center">
		<input class="button10g" type="button" style="width:100" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" style="width:100" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" style="width:100" name="Update" value=" Update ">
		</td>	
	</TR>
	
	</cfoutput>
		
</TABLE>

</CFFORM>

</cf_divscroll>
