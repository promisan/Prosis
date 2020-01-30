
<!--- template to capture additional information on the PA action on the Profile level --->


<cfparam name="field" default="">

<!-- <cfform> -->

<cfoutput>

	<table width="96%" align="center" cellspacing="0" cellpadding="0" style="border-left: 1px solid silver;" class="formpadding">
		
		<tr class="line"><td colspan="3" height="17" style="font-size:15px;height:30px;padding-left:10px" class="labelmedium">#field# <cf_tl id="Amendment"></td></tr>
		
				
		<tr><td></td></tr>
		<tr>
			
			  <td width="180" class="labelmedium" style="padding-left:10px"><cf_tl id="Change effective">:</td>
			  <td width="160">
			 			   
			     <cf_intelliCalendarDate9
					FieldName="#field#Effective" 
					Default="#dateformat(now(),client.dateformatshow)#"
					class="regularxl"	
					manual="false"			
					AllowBlank="True">	
					
							
			</td>
			<td class="labelmedium">
			
				<cfparam name="prior" default="">			
				<cf_tl id="was"> : 
				<cfif prior eq "">
					<font color="408080">#evaluate("Person.#field#")#</font>
				<cfelse>
					<font color="408080">#prior#</font>
				</cfif>
			
			</td>
		</tr>	
		<tr>
			 <td width="180" class="labelmedium" style="padding-left:10px"><cf_tl id="Remarks">:</td>
			<td colspan="2" style="padding-right:10px">
			
				  <textarea type="text" 
				       class="regular" 
					   name="#field#Remarks" 
					   style="font-size:13px;padding:3px;height:40;width:100%"></textarea>
			
			</td>	
		</tr>
				
	
	</table>

</cfoutput>

<cfset ajaxonload("doCalendar")>

<!-- </cfform> -->



