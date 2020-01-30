 
 <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-top:1px solid silver" class="formpadding">
	<tr>
	<td colspan="2" style="padding-left:5px;padding-top:7px;height:26" class="labellarge">
	<cf_tl id="Submit budget action"></td>
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
			
	<tr><td width="200" class="labelmedium" style="padding-left:10px"><cf_tl id="Amount">:</td>
	    <td style="padding-left:10px" id="amountaction"></td>
	</tr>
	
	<!--- only if we have a donor --->
	
	<cfif Parameter.EnableDonor eq "1" and Edit.BudgetEntryMode eq "1">	
			
		<tr><td width="200" class="labelmedium" valign="top" style="padding-top:3px;padding-left:10px"><cf_tl id="Donor">:</td>
		    <td id="amountdonor" style="padding-right:30px"></td>
		</tr>
		<tr><td height="5"></td></tr>
		
	<cfelse>
	
		<tr class="hide"><td id="amountdonor" style="padding-right:30px"></td></tr>	
	
	</cfif>
		
	<tr>
		<td width="200" class="labelmedium" style="padding-left:10px"><cf_tl id="Transaction Date">:</td>
		<td style="padding-left:10px">
		
		<cf_calendarscript>
		
		<cf_intelliCalendarDate9
					FieldName="TransactionDate" 
					Manual="True"	
					class="regularxl"						
					DateValidStart="#Dateformat(Period.DateEffective, 'YYYYMMDD')#"
					DateValidEnd="#Dateformat(Period.DateExpiration, 'YYYYMMDD')#"
					Default="#dateformat(now(),client.dateformatshow)#"
					AllowBlank="False">	
		
		</td>
	</tr>
	
	<tr>
		<td width="100" class="labelit" style="padding-left:10px;padding-top:3px" valign="top">Remarks:</td>
		<td style="padding-left:10px">
		
		<textarea class="regular" onkeyup="return ismaxlength(this)" 
		     style="width:98%;height:30;padding:4px;font-size:13px" name="ActionMemo" totlength="150"></textarea>
						
		</td>
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" style="height:30" align="center">
	
		 <cf_tl id="Submit" var="1">
	 
	 	<cfoutput>
		 <input 
			value       = "#lt_text#" 		
			type        = "button"
			id          = "submit"					
			onclick     = "Prosis.busy('yes');ColdFusion.navigate('AllotmentSubmit.cfm','processbox','','','POST','clear')"
			style       = "width:170;font-size:13px;height:36px" 					
			class       = "button10g">   
			</cfoutput>
	
	</td></tr>
	
</table>
	
