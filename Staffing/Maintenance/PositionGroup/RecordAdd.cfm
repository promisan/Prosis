

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Classification" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<script>
	function hl(act){
   	 	 
		 sel = document.getElementById("ShowInColor");
		 	 
		 if (act == "hide")
		 { sel.className = "Hide" ; 
		   sel.value = "";
		 }
		 else
		 { sel.className = "labelmedium" ; }
			
	  }
	  
</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" class="formpadding">

    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="GroupCode" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Usage:</TD>
    <TD>
	   <select class="regularxl" name="GroupDomain">
					<option value="Position" SELECTED>Position</option>
					<option value="Assignment">Assignment</option>
		</select>
     </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40"class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Show in view:</TD>
    <TD class="labelmedium">
	   <input type="radio" name="ShowInView" value="0" checked onClick="hl('hide')">No
	   <input type="radio" name="ShowInView" value="1" onClick="hl('show')">Yes
	   &nbsp;
	   <input type="text" class="hide" name="ShowInColor" value="" size="10" maxlength="10">
    </TD>
	</TR>
	
	<tr>
		<td class="labelmedium" valign="top"></td>
		<td>
							
			<cfquery name="Mission"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	Mission,
						(SELECT MissionOwner FROM Organization.dbo.Ref_Mission WHERE Mission = M.Mission) as Owner
				FROM   	Ref_ParameterMission M
				WHERE     Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1)
				ORDER BY Owner
			</cfquery>
			
			
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			<cfoutput query="Mission" group="owner">
				<tr><td colspan="3" class="labellarge"><cfif owner eq "">Undefined<cfelse>#owner#</cfif></b></td></tr>
				<tr><td class="line" colspan="3"></td></tr>
				<cfset cnt = 0>
				<cfoutput>
					
					<cfset cnt = cnt+1>
					<cfif cnt eq "1"><tr></cfif>
					<td>
					<label>
						<input type="checkbox" name="Mission" value="#Mission#">
						#Mission#
					</label>
					</td>
					<cfif cnt eq "3">
						</tr>
						<cfset cnt=0>
					</cfif>
				</cfoutput>
				
				<tr><td height="7"></td></tr>
						
			</cfoutput>
			</table>
		
		</td>
	</tr>
	
	<tr><td height="6" colspan="2"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="6" colspan="2"></td></tr>
	<tr>
		<td align="center" colspan="2">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" value=" Submit ">
		</td>	
	</tr>
	
	
</table>

	

</CFFORM>


</BODY></HTML>