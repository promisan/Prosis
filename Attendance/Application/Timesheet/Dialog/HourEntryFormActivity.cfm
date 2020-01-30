<table width="100%" border="0">
	
				  	
	<cfoutput query="Workaction">
					
		<tr class="line" style="border-top:0px solid silver">
		
			<td bgcolor="#viewcolor#" style="cursor: pointer;" onclick="actionclass[#currentrow-1#].click()">
			 	 
				 <table cellspacing="0" cellpadding="0">
				  <tr style="height:35px">
				  
				    <td width="25" align="center">
					
				      <input type="radio" 
					     onClick="details(this.value,'#ProgramLookup#');setcolor()" 
				  		 name="actionclass" style="width:18px;height:18px" 
						 id="actionclass" 
						 value="#ActionClass#" 
						<cfif last.ActionClass eq ActionClass>checked</cfif>>
				    </td>
				    <td class="labelmedium" style="font-size:17px;padding-left:4px">#timeparent#:<cf_tl id="#ActionDescription#"></td>				  
					
				  </tr>
				  </table>		
			</td>
		</tr>
		
		<cfif ProgramLookup eq "1">
		
			<tr class="activitydetail" id="detail_#ActionClass#">		
			<td style="padding-left:15;padding-bottom:4px;width:550;border:0px solid silver">
									   
			    <cfif last.ActionClass eq ActionClass>
				
					<cfdiv id="details_#ActionClass#" style="width:100%"
					    bind="url:HourEntryFormActivitySelect.cfm?id=#URL.id#&date=#url.date#&hour=#URL.hour#&slot=#url.slot#&actionclass=#last.actionClass#&actioncode=#last.actioncode#"/>
						
				<cfelse>
				
					<cfdiv id="details_#ActionClass#" style="width:100%"/>			
				
				</cfif>	
					
			</td>	
			</tr>
		
		</cfif>
			
	</cfoutput>
			
</table>	