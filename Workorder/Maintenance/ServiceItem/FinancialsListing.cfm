
<cfoutput>

<cfform action="FinancialsSubmit.cfm?id1=#url.id1#" method="post" name="editformFinancials">

<table width="95%" align="center" class="formpadding" cellspacing="0" cellpadding="0" class="navigation_table">

<tr><td height="15"></td></tr>
	<tr class="labelmedium2 line fixlengthlist">
	  <td>Name &nbsp;</td>
	  <td align="center" style="cursor:pointer" title="Operational">O</td>
	  <td align="center" style="cursor:pointer" title="Show Expired Lines">S</td>
	  <td align="center" style="cursor:pointer" title="Expiration Days">Exp.Days</td>
	  <!---
	  <td>Journal</td>
	  --->
	  <td style="cursor:pointer" title="Define the date charges will be recalculated for this services for each batch run">Charges Calculate</td>
	  <td style="cursor:pointer" title="Define the date as of which financial posting should commence for this service">Posting Start</td>
	  <td style="cursor:pointer" title="Define the date as of which financial posting should calculate for this service">Posting Calculate</td>
	  <td style="cursor:pointer" title="Define the date as of which portal tagging should commence for this service">Portal date</td>
	  <td style="cursor:pointer" align="center">Posting Details</td>
	</tr>
		
	 <cfquery name="Mis" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission	
		WHERE  Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'WorkOrder')
	</cfquery>
	
	<cfloop query="Mis">
			
		<cfquery name="getMission" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   ServiceItemMission
			WHERE  ServiceItem = '#url.id1#'		
			AND    Mission = '#mission#'
		</cfquery>
			
		<tr class="navigation_row line fixlengthlist">
	     	<td class="labelmedium" height="27">#Mission#</td>	
			
		    <td align="center">
				<input type="Checkbox" class="radiol" name="#mission#_Operational" id="#mission#_Operational" <cfif GetMission.Operational eq "1">checked</cfif>>
			</td>
			
			<td align="center" style="padding-left:3px">	
				<input type="Checkbox" class="radiol" name="#mission#_ShowExpiredLines" id="#mission#_ShowExpiredLines" <cfif GetMission.SettingShowExpiredLines eq "1">checked</cfif>>
			</td>
			
			<td align="center">
			
				<cfinput type="Text" 
					name="#mission#_DaysExpiration" 
	                id="#mission#_DaysExpiration"
					value="#getMission.SettingDaysExpiration#" 
					required="No" 
					message="Please, enter a valid positive integer for expiration days for #mission#." 
					size="1" 
					maxlength="3" 
					validate="integer" 
					range="0," 
					class="regularxl" 
					style="text-align:center;">
			</td>
			
			<!---
			<td> 
						
			 <cfquery name="getJournal" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM Journal
					WHERE Mission = '#mission#'			
				</cfquery>
				
				<select name="#mission#_Journal" id="#mission#_Journal" style="width:150px"  class="regularxl">
			        <option value="">[<cf_tl id="undefined">]</option>
					<cfloop query="getJournal">
					<option value="#Journal#" <cfif getJournal.journal eq journal>selected</cfif>>#Journal# #Description#</option>
					</cfloop>
			
				</select>
								   	
			</td>
			
			--->
			<td style="z-index:#20-currentrow#; position:relative; padding-top:3px;">			
			
				<cf_intelliCalendarDate9
				FieldName="#mission#_DateChargesCalculate"
				Tooltip="Define the date charges will be recalculated for this services for each batch run"
				Message="Select a valid Charges Calc. Date"
				class="regularxl"
				Default="#dateformat(getMission.DateChargesCalculate, CLIENT.DateFormatShow)#"
				AllowBlank="True">
				
			</td>
			
			<td style="z-index:#20-currentrow#; position:relative; padding-top:3px;">
			
				<cf_intelliCalendarDate9
				FieldName="#mission#_DatePostingStart"
				Tooltip="Define the date as of which financial posting should commence for this service"
				Message="Select a valid Posting Calc. Date"
				class="regularxl"
				Default="#dateformat(getMission.DatePostingStart, CLIENT.DateFormatShow)#"
				AllowBlank="True">
				
			</td>
			
			<td style="z-index:#20-currentrow#; position:relative; padding-top:3px;">
			
				<cf_intelliCalendarDate9
				FieldName="#mission#_DatePostingCalculate"
				Tooltip="Define the date as of which financial posting should calculate for this service"
				Message="Select a valid Posting Calc. Date"
				class="regularxl"
				Default="#dateformat(getMission.DatePostingCalculate, CLIENT.DateFormatShow)#"
				AllowBlank="True">
				
			</td>
			
			<td style="z-index:#20-currentrow#; position:relative; padding-top:3px;">
			
				<cf_intelliCalendarDate9
				FieldName="#mission#_DatePortalProcessing"
				Tooltip="Define the date as of which portal tagging should commence for this service"
				Message="Select a valid Portal Proc. Date"
				class="regularxl"
				Default="#dateformat(getMission.DatePortalProcessing, CLIENT.DateFormatShow)#"
				AllowBlank="True">
				
			</td>
			
			<td align="center">
				<table width="100%" align="center">
					<tr>
						<td align="right" width="99%" class="labelit">
							<cfdiv id="detailMissionPosting_#mission#"  bind="url:Financials_MissionPosting.cfm?id1=#url.id1#&id2=#mission#">
						</td>
						<td style="padding-left:4px">							
							<img src="#SESSION.root#/Images/addline.png" 
							style="cursor: pointer;" title="Add Mission Postings" width="13" height="14" border="0" align="absmiddle" 
							onClick="javascript: addMissionPosting('#url.id1#', '#mission#');"	>	
						</td>
					</tr>
				</table>			
			</td>	
				
		</tr>
			
	</cfloop>
	
	<tr><td height="5"></td></tr>		
	
	<tr><td height="1" colspan="10" class="line"></td></tr>
	
	<tr>
	<td colspan="10" align="center" height="36">
		<input class="button10g" type="submit" name="Update" id="Update" value=" Save ">	
	</td>
	</tr>
		
</tr>
</table>

</cfform>

</cfoutput>

<cfset ajaxonload("doCalendar")>