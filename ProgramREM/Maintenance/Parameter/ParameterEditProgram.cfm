<cfajaximport tags="cfform">

<cfquery name="Get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfoutput query="get">

<cfform method="POST" name="parameterprogram" action="ParameterSubmitProgram.cfm?idmenu=#URL.Idmenu#&mission=#URL.mission#">

<table width="96%" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td height="12"></td></tr>
		
	    <TR class="LabelMedium">
	    <td style="width:200px">Hide entry Goal:</b></td>
	    <TD colspan="3">
		   <table><tr class="LabelMedium">
		   <td><input type="radio" class="radiol" name="EnableObjective" value="1" <cfif EnableObjective eq "1">checked</cfif>></td>
		   <td style="padding-left:5px">No</td>
		   <td style="padding-left:8px"><input type="radio" class="radiol" name="EnableObjective" value="0" <cfif EnableObjective eq "0">checked</cfif>></td>
		   <td style="padding-left:5px">Yes</td>
		   </tr>
		   </table>
	    </TD>
		</TR>	
		<tr><td></td></td><td colspan="3" class="LabelMedium" style="color:gray;">Hides entry of Goal and Objective on the program definition level.</td></tr>
		<tr><td colspan="4" height="10px"></td></tr>
		
		
	    <TR class="LabelMedium">
	    <td width="150" class="header">Default Program dialog:</td>
	    <TD>
		<table><tr class="LabelMedium">
		   <td>	<input type="radio" class="radiol" name="DefaultOpenProgram" <cfif DefaultOpenProgram eq "Activity">checked</cfif> value="Activity"></td>
		   <td style="padding-left:5px">Activity</td>
		   <td style="padding-left:8px"><input type="radio" class="radiol" name="DefaultOpenProgram" <cfif DefaultOpenProgram eq "Target">checked</cfif> value="Target"></td>
		   <td style="padding-left:5px">Target</td>
		    </tr>
		   </table>
	    </td>
	    </tr>
		
	 	<tr><td class="header"></td><td colspan="3" class="LabelMedium" style="color:gray;">The dialog that opens automatically when viewing a program.</td></tr>
	 	<tr><td colspan="4" height="10px"></td></tr>
							
	    <TR class="LabelMedium">
	    <td class="regular">Enforce Memo:</b></td>
	    <TD class="regular" colspan="3">
		      <table><tr class="LabelMedium">
		       <td><input type="radio" class="radiol" name="ProgressMemoEnforce" value="1" <cfif ProgressMemoEnforce eq "1">checked</cfif>></td>
			   <td style="padding-left:5px">Yes</td>
			   <td style="padding-left:8px"><input type="radio" class="radiol" name="ProgressMemoEnforce" value="0" <cfif ProgressMemoEnforce eq "0">checked</cfif>></td>
			   <td style="padding-left:5px">No</td>
		   </tr>
		   </table>
	    </TD>
		</TR>	
	
		<tr><td></td><td class="LabelMedium" colspan="3" style="color:gray">Defines if a progress report should have <b>additional clarification or remarks</b> entered.</td></tr>
		<tr><td colspan="4" height="10px"></td></tr>
					
		<TR class="LabelMedium">
	    <td class="regular">Carry-over mode:</b></td>
	    <TD class="regular" colspan="3">
			<table><tr class="LabelMedium">
		       <td><input type="radio" class="radiol" name="CarryOverMode" value="Limited"  <cfif CarryOverMode eq "Limited">checked</cfif>></td>
			   <td style="padding-left:5px">Limited</td>
		       <td style="padding-left:8px"><input type="radio" class="radiol" name="CarryOverMode" value="Extended" <cfif CarryOverMode eq "Extended">checked</cfif>></td>
			   <td style="padding-left:5px">Extended</td>
			   </tr>
		   </table>
	    </TD>
		</TR>	
	
		<tr><td></td><td class="LabelMedium" style="color:gray;" colspan="3">Extended mode will <b>also</b> carry-over program requirements, allotments as well as target and activity/output information to the next period and associated edition.</td></tr>
		<tr><td colspan="4" height="10px"></td></tr>
				
	    <TR class="LabelMedium">
	    <td>Output entry mode:</b></td>
	    <TD colspan="3">
		    <table><tr class="LabelMedium">
		       <td><input type="radio" class="radiol" name="OutputInterface" value="1" <cfif OutputInterface eq "1">checked</cfif>></td>
			   <td style="padding-left:5px">All</td>
		       <td style="padding-left:8px"><input type="radio" class="radiol" name="OutputInterface" value="0" <cfif OutputInterface eq "0">checked</cfif>></td>
			    <td style="padding-left:5px">Limited</td>
			   </tr>
		   </table>
	    </TD>
		</TR>	
		
		<tr><td height="10"></td></tr>	
		
	<tr class="line"><td height="1" colspan="4"></td></tr>	
						
	<tr><td height="40" colspan="4" align="center">	
		<input type="Submit" name="Save" value="Update" class="button10g">
	</td></tr>
	
		
</table>
</cfform>
	
</cfoutput>	