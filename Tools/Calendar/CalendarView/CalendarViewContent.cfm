
<script>
	 _cf_loadingtexthtml='';
</script>

<cfset condition = replaceNoCase(url.condition,'|','&','ALL')>
<cfset condition = replaceNoCase(condition,'!','=','ALL')>

<!--- temp variable --->

<CF_DateConvert Value="#url.selecteddate#">

<cfset dateob = dateValue>

<cfif month(dateob) neq month(now())>
  <cfset url.selecteddate = "#day(dateob)#/#month(dateob)#/#year(dateob)#">
  <CF_DateConvert Value="#url.selecteddate#">
  <cfset dateob = dateValue>
</cfif>

<cfif url.preparation neq "">
	<cfinclude template="../../../#url.preparation#">
</cfif>

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

<cfset client.selecteddate = dateob>

<cfif url.cellw eq "fit">
   <cfset url.cellw = "14%">  
</cfif>

<cfif url.cellh eq "fit">
   <cfset url.cellh = "18%">  
</cfif>

<script>
	<cfoutput>	   
	  try {	document.getElementById('#url.fieldname#').value = '#dateformat(dateob,CLIENT.DateFormatShow)#' } catch(e) {}		 
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

<cfif url.direction eq "jump">
	
	<script language="JavaScript">   
		  try {	  
		  menuleft     = document.getElementById('celltargetleft').value;
		  condition    = document.getElementById('cellcondition').value;	 	 
		  if (menuleft != '') {
			   ptoken.navigate('<cfoutput>#SESSION.root#</cfoutput>/'+menuleft+'?'+condition+'&selecteddate=<cfoutput>#dateformat(dateob,CLIENT.DateFormatShow)#</cfoutput>','targetleft')
		  }	   
		  } catch(e) {}
	</script>	

</cfif>

<table width="99%" height="99%">

	<tr class="hide"><td id="calendarprocess"></td></tr>

	<cfoutput>
	
	<tr style="height:10px" class="labelmedium">
		<td width="#url.cellw#" style="font-weight:200" align="center"><cf_tl id="_CalendarSunday"></td>
		<td width="#url.cellw#" style="font-weight:200" align="center"><cf_tl id="_CalendarMonday"></td>
		<td width="#url.cellw#" style="font-weight:200" align="center"><cf_tl id="_CalendarTuesday"></td>
		<td width="#url.cellw#" style="font-weight:200" align="center"><cf_tl id="_CalendarWednesday"></td>
		<td width="#url.cellw#" style="font-weight:200" align="center"><cf_tl id="_CalendarThursday"></td>
		<td width="#url.cellw#" style="font-weight:200" align="center"><cf_tl id="_CalendarFriday"></td>
		<td width="#url.cellw#" style="font-weight:200" align="center"><cf_tl id="_CalendarSaturday"></td>
	</tr>
	
	</cfoutput>
	
	<!--- Now we need to display the weeks of the month. --->
	<!---  The logic here is not too complex. We know that every 7 days we need to start a new table row. The only hard part is figuring out how much we need to pad the first and last row. To figure out how much we need to pad, we just figure out what day of the week the first of the month is. if it is wednesday, then we need to pad for sunday,monday, and tuesday. 3 days. --->
					
	<tr>	
		
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
    <cfparam name="url.conditionfly" default="">
		
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
				onmouseout="hlx(this,false)"			
				onClick="calendardetail('#URLEncodedFormat(date)#'); calselected(this,'#dateformat(date,client.dateformatshow)#','#url.fieldname#','#url.pfunction#');">
										
		</cfif>
		
	<cfelse>	
	
		<td bgcolor="<cfif today eq x and month(now()) eq month(date)>b1c7e0<cfelseif url.selecteddate eq dateformat(date,CLIENT.DateFormatShow)>d4d4d4<cfelse>ffffff</cfif>" 
			valign="top" 
			id="cal#x#"
			width="#url.cellw#" height="#url.cellh#" 	
			style="border:1px solid silver; cursor:pointer; background-color:<cfif x eq day(dateob)>silver<cfelse>white</cfif>"		
			onmouseover="hlx(this,true)"
			onmouseout="hlx(this,false)"			
			onClick="calendardetail('#URLEncodedFormat(date)#'); calselected(this,'#dateformat(date,client.dateformatshow)#','#url.fieldname#','#url.pfunction#');">
			
	</cfif>			     			
						
			<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0" bgcolor="<cfif DayOfWeek(date) eq '1' or DayOfWeek(date) eq '7'>e6e6e6</cfif>">
				<tr>
				<td height="20" valign="top" style="font-size:17px;padding-top:4px;padding-left:4px">#X#</td>
				<td></td>
				</tr>						
				<tr>							
					<td colspan="2" valign="top" id="calendarday_#x#" width="100%" height="100%" style="padding:5px; min-width:60px; max-width:125px;-webkit-border-radius: 5px;-moz-border-radius: 5px;border-radius: 5px;">																				
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
      
  <!--- destination --->
  
  <cfif url.target neq "" and url.targetid eq "">
  
	  <tr><td height="100%" colspan="7" id="calendartarget" style="padding-top:15px" valign="top" align="center">
	    		
	  	 <cfset url.selecteddate = dateob>					 

	    <cfinclude template="#url.relativepath#/#url.target#">		 		 			 		
		 	  
	  </td></tr>
	  
 <cfelseif url.target neq "" and url.targetid neq "">
 
    <cfoutput>	
	<!--- populates the screen for each cell of the calendar with a summary --->	
 	<script>			    
	   if (document.getElementById('#url.targetid#')) {
	   
	     try { 		   
		   	 if ($('##mybox_borderCENTER').is(':visible')) {
			 	size = 'small'
			    } else  { size = 'full'  }			 
				
			 } catch(e) { size = 'small' }
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#session.root#/#url.target#?selecteddate=#URLEncodedFormat(dateob)#&'+document.getElementById('cellcondition').value+'&'+document.getElementById('cellconditionfly').value+'&size='+size,'#url.targetid#')
		}
	</script>	
	</cfoutput>	  
  
  </cfif>
    
</table>

<script>
	Prosis.busy('no')
</script>