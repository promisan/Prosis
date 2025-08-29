<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfset condition = replaceNoCase(url.condition,'|','&','ALL')>
<cfset condition = replaceNoCase(condition,'!','=','ALL')>

<!--- temp variable --->

<CF_DateConvert Value="#url.selecteddate#">
<cfset dateob = dateValue>

<cfparam name="url.direction" default="none">

<cfif url.direction eq "none">
	
<cfelseif url.direction eq "jump">
	
	<!--- use cf code --->
	<cfoutput>
		<script>
			document.getElementById('currentmonth').innerHTML = "#year(dateob)#";
		</script>
	</cfoutput>
	
<cfelseif url.direction eq "back">
	<cfset dateob = DateAdd("m",-1,dateob)>   
<cfelse>
   	<cfset dateob = DateAdd("m",1,dateob)>
</cfif>

<cfset client.selecteddate = "#dateob#">

<cfif url.cellw eq "fit">
  <cfset url.cellw = "14%">  
</cfif>

<script>
	<cfoutput>	   	
		try { document.getElementById('#url.fieldname#').value = '#dateformat(dateob,CLIENT.DateFormatShow)#' } catch(e) {}	
	</cfoutput>
</script>

<cfif url.daterange eq "todate" and month(now()) lte month(dateob)>

	<script>
		try { document.getElementById('cellmonthnext').className = "hide" } catch(e) {}		
	</script>

<cfelse>

	<script>
		try { document.getElementById('cellmonthnext').className = "regular" } catch(e) {}
	</script>

</cfif>

<!--- determine of we are going to refresh the left menu box --->

<script language="JavaScript">   
	  try {
	  menuleft     = document.getElementById('celltargetleft').value;
	  condition    = document.getElementById('cellcondition').value;	 
	  if (menuleft != '') {
		   ColdFusion.navigate('<cfoutput>#SESSION.root#</cfoutput>/'+menuleft+'?'+condition+'&selecteddate=<cfoutput>#dateformat(dateob,CLIENT.DateFormatShow)#</cfoutput>','targetleft')
	  }	   
	  } catch(e) {}
</script>	

<table width="100%" height="100%" border="0">

	<cfoutput>		
	<tr class="labelit" style="height:23px;">
	<td width="#url.cellw#" align="center"><cf_tl id="S"></td>
	<td width="#url.cellw#" align="center"><cf_tl id="M"></td>
	<td width="#url.cellw#" align="center"><cf_tl id="T"></td>
	<td width="#url.cellw#" align="center"><cf_tl id="W"></td>
	<td width="#url.cellw#" align="center"><cf_tl id="T"></td>
	<td width="#url.cellw#" align="center"><cf_tl id="F"></td>
	<td width="#url.cellw#" align="center"><cf_tl id="S"></td>
	</tr>	
	</cfoutput>
	
	<!--- Now we need to display the weeks of the month. --->
	<!---  The logic here is not too complex. We know that every 7 days we need to start a new table row. The only hard part is figuring out how much we need to pad the first and last row. To figure out how much we need to pad, we just figure out what day of the week the first of the month is. if it is wednesday, then we need to pad for sunday,monday, and tuesday. 3 days. --->
					
	<tr height="10">	
		
	<cfset FIRSTOFMONTH=CreateDate(Year(DateOb),Month(DateOb),1)>
	<cfset ENDOFMONTH=CreateDate(Year(DateOb),Month(DateOb),DaysInMonth(DateOb))>
	
	<cfset TOPAD=DayOfWeek(FIRSTOFMONTH) - 1>		
	<cfset PADSTR=RepeatString("<td width=#url.cellw# style='border:0px solid silver' bgcolor=ffffff>&nbsp;</td>",TOPAD)>
	<!--- emtpty days --->
	<cfoutput>#PADSTR#</cfoutput>
	<cfset DW=TOPAD>
	
	<cfparam name="url.action" default="">
																						
	<cfloop index="X" from="1" to="#DaysInMonth(DateOb)#">
	
	<cfset date=CreateDate(year(dateob),month(dateob),x)>
	<cfset today = Day(dateob)>	

	<cfoutput>
	
	<!--- onMouseOver="hl(this,true,'#x#-#attributes.startmonth#-#attributes.startyear#')" 
			onMouseOut="hl(this,false,'')" --->
			
	<cfparam name="url.selecteddate" default="">
	
	<cfif url.isDisabled eq 1>
	
		<!--- Define if it is a valid date --->
		<cfset isValid = 0>
		<cfif findnocase(dateFormat(date,'yyyymmdd'), SESSION.calendarViewValidDates) neq 0>
			<cfset isValid = 1>
		</cfif>
								
		<cfif isValid eq 0>
		
			<td bgcolor="E8E8E8" 
				valign="top" 
				id="cal#x#"
				width="#url.cellw#" height="#url.cellh#" 	
				style="border:1px solid silver;">
		
		<cfelse>
				
			<td bgcolor="<cfif today eq x and month(now()) eq month(date)>b1c7e0<cfelseif url.selecteddate eq dateformat(date,CLIENT.DateFormatShow)>d4d4d4<cfelse>ffffff</cfif>" 
				valign="top" id="cal#x#" width="#url.cellw#" height="#url.cellh#" 	
				style="border:1px solid gray; cursor:pointer; background-color:<cfif x eq day(dateob)>silver<cfelse>white</cfif>"		
				onmouseover="hlx(this,true)"
				onmouseout="hlx(this,false)" onclick="calselected(this,'#dateformat(date,client.dateformatshow)#','#url.fieldname#','#url.pfunction#');">
		
		</cfif>
		
	<cfelse>	
	
		<td bgcolor="<cfif today eq x and month(now()) eq month(date)>b1c7e0<cfelseif url.selecteddate eq dateformat(date,CLIENT.DateFormatShow)>d4d4d4<cfelse>ffffff</cfif>" 
			valign="top" 
			id="cal#x#"
			width="#url.cellw#" height="#url.cellh#" 	
			style="border:1px solid silver; cursor:pointer; background-color:<cfif x eq day(dateob)>silver<cfelse>white</cfif>;"		
			onmouseover="hlx(this,true)"
			onmouseout="hlx(this,false)" onclick="calselected(this,'#dateformat(date,client.dateformatshow)#','#url.fieldname#','#url.pfunction#');">
			
	</cfif>			      			
			
			<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0" id="calcontent#x#">							                                      
			
			<tr>			
				<td height="20" valign="top" style="min-width:20px;font-size:11px;padding-top:2px;padding-left:4px">#X#</td>
				<td style="height:100%;padding:1px;padding-top:6px;width:100%">
				<cfset url.calendardate = date>		
						
						<cfparam name="url.mission" default="">			
						<cfif url.content neq "">
						    <cfif url.relativepath neq "">						
							<cfinclude template="#url.relativepath#/#url.content#">		
							<cfelse>
							<cfinclude template="#url.content#">		
							</cfif>
						</cfif>			
				</td>
				</tr>																
										
			</table>

	    </td>
				<cfset DW=DW + 1>
				<cfif DW EQ 7>
 			    	</tr>
  		    		<cfset DW=0>
		   		    <cfif X LT DaysInMonth(DateOb)><tr></cfif>
    		    </cfif>			

		</cfoutput>			
		
	</cfloop>
								
	<!--- Now we need to do a pad at the end, just to make our table "proper"  we can figure out how much the pad should be by examining DW --->
	
	<cfset TOPAD=7 - DW>
	<cfif TOPAD LT 7>
		<cfset PADSTR=RepeatString("<td width=#url.cellw# style='border:0px solid silver' bgcolor=ffffff>&nbsp;</td>",TOPAD)>
		<!--- emtpty days --->
		<cfoutput>#PADSTR#</cfoutput>
	</cfif>
	
  </tr>
  
</table>


<script>
	Prosis.busy('no')
</script>