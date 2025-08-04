<!--
    Copyright © 2025 Promisan

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

<cfparam name="attributes.Name"            default="activecalendar">
<cfparam name="attributes.FieldName"       default="seldate">
<cfparam name="attributes.Title"           default="My Calendar">

<cfparam name="url.selecteddate"           default="#now()#">

<cfif url.selecteddate eq "">
	<cfset url.selecteddate = now()>
</cfif>

<cfparam name="attributes.selecteddate"    default="#url.selecteddate#">

<cfparam name="attributes.year"            default="#Year(attributes.selecteddate)#">
<cfparam name="attributes.month"           default="#Month(attributes.selecteddate)#">
<cfparam name="attributes.day"             default="#day(attributes.selecteddate)#">

<cfparam name="attributes.style"           default="border:0px solid silver">

<cfparam name="attributes.datestart"       default="01/01/2010">
<cfparam name="attributes.dateend"         default="01/01/2020">
<cfparam name="attributes.daterange"       default="all">
<cfparam name="attributes.mode"            default="standard">
<cfparam name="attributes.pfunction"       default="">
<cfparam name="attributes.relativepath"    default="">
<cfparam name="attributes.condition"       default="">
<cfparam name="attributes.conditionfly"    default="">

<cfparam name="attributes.autorefresh"     default="0">

<cfparam name="attributes.preparation"     default="">
<cfparam name="attributes.content"         default="">
<cfparam name="attributes.targetid"        default="">
<cfparam name="attributes.target"          default="">
<cfparam name="attributes.targetleft"      default="">
<cfparam name="attributes.targetleftdate"  default="">
<cfparam name="attributes.height"          default="">
<cfparam name="attributes.scroll"          default="Yes">
<cfparam name="attributes.cellwidth"       default="85">
<cfparam name="attributes.cellheight"      default="85">
<cfparam name="attributes.isDisabled"      default="0">
<cfparam name="attributes.validDates"      default=""> <!--- comma separated list in the format YYYYMMDD --->
<cfparam name="attributes.showJump"        default="1">
<cfparam name="attributes.showRefresh"     default="1">
<cfparam name="attributes.showPrint"       default="1">
<cfparam name="attributes.showToday"       default="0">
<cfparam name="attributes.showPrevious"    default="1">
<cfparam name="attributes.showNext"        default="1">

<cfif attributes.cellheight eq "fit" or attributes.scroll eq "Yes">
	<cfset ht = "100%">
<cfelse>
	<cfset ht = "#attributes.cellheight*8#">	
</cfif>

<cfset dateob = createdate(attributes.year,attributes.month,attributes.day)>  

<cfoutput>	

<div class="clsPCalendarTitle" style="display:none;">#ucase(attributes.title)#</div>
<div class="clsPCalendarView" style="height:#ht#;">

<table width="100%" height="#ht#" style="<cfoutput>#attributes.style#</cfoutput>" class="formpadding clsPCalendarViewTable">

		<!--- pass all variables --->
		<cfset condition = replaceNoCase(attributes.condition,'&','|','ALL')>
		<cfset condition = replaceNoCase(condition,'=','!','ALL')>	
					
		<cfif attributes.autorefresh gte "1">
		
			<script>		
			<!--- reset any backoffice scripts that might be still running --->
			 try { clearInterval ( calendarrefresh_#attributes.name# ) } catch(e) {}						
			 calendarrefresh_#attributes.name# = setInterval('calendarmonth("","none","#attributes.mode#","#attributes.fieldname#")','#attributes.autorefresh*1000#') 						
			</script>
	   
	    </cfif>		
				
		<!--- select field --->		
		<input type="hidden"    id="#attributes.fieldname#" name="#attributes.fieldname#" value="<cfoutput>#dateformat(dateob,CLIENT.DateFormatShow)#</cfoutput>">						
		
		<input type="hidden"      id="fselected" value="#dateFormat(now(),client.dateFormatShow)#"> <!--- holds the current date --->
			
		<input type="hidden"    id="cellfunction"        name="cellfunction"       value="#attributes.pfunction#">	
		<input type="hidden"    id="cellfieldname"       name="cellfieldname"      value="#attributes.fieldname#">		
		<input type="hidden"    id="selecteddate"        name="selecteddate"       value="#attributes.selecteddate#">	
		<input type="hidden"    id="cellwidth"           name="cellwidth"          value="#attributes.cellwidth#">
		<input type="hidden"    id="cellheight"          name="cellheight"         value="#attributes.cellheight#">
		<input type="hidden"    id="cellpreparation"     name="cellpreparation"    value="#attributes.preparation#">
		
		<input type="hidden"    id="cellcondition"       name="cellcondition"      value="#attributes.condition#">	
		<input type="hidden"    id="cellconditionurl"    name="cellconditionurl"   value="#condition#">				
		<input type="hidden"    id="cellconditionfly"    name="cellconditionfly"   value="#attributes.conditionfly#">	
		
		<input type="hidden"    id="cellcontent"         name="cellcontent"        value="#attributes.content#">
		<input type="hidden"    id="cellrelativepath"    name="cellrelativepath"   value="#attributes.relativepath#">
		<input type="hidden"    id="celltarget"          name="celltarget"         value="#attributes.target#">
		<input type="hidden"    id="celltargetid"        name="celltargetid"       value="#attributes.targetid#">
		<input type="hidden"    id="celltargetleft"      name="celltargetleft"     value="#attributes.targetleft#">
		<input type="hidden"    id="celltargetleftdate"  name="celltargetleftdate" value="#attributes.targetleftdate#">
		<input type="hidden"    id="celldaterange"       name="celldaterange"      value="#attributes.daterange#">
		<input type="hidden"    id="cellIsDisabled"      name="cellIsDisabled"     value="#attributes.isDisabled#">			
		<input type="hidden"    id="mode"                name="mode"               value="#attributes.Mode#">		
		<input type="hidden"    id="showToday"           name="showToday"          value="#attributes.showToday#">		
		<input type="hidden"    id="showPrint"           name="showPrint"          value="#attributes.showPrint#">		
		<input type="hidden"    id="showRefresh"         name="showRefresh"        value="#attributes.showRefresh#">		
										
		<tr bgcolor="white">
		
		<td width="100%" style="padding:1px" align="left" valign="top">		
													
			<table width="100%" border="0" style="padding:2px;border:0px solid silver">
									
			<tr class="clsNoPrint">			
						
			<cfif attributes.mode eq "standard">
						
				<td width="90%" colspan="2" style="padding-top:10px;height:35px" valign="top">
					<table style="width:100%" class="formpadding">
					
					<cfoutput>
					<tr>						
						<td id="currentmonth" name="currentmonth" class="labellarge" style="width:70px;font-weight:normal;font-size:31px;padding-left:4px; color:black;">						
						#year(dateob)#
						</td>
						<td class="labellarge fixlength" style="padding-top:9px;padding-left:10px;font-size:22px;">#attributes.title#</td>
						
						<cfif attributes.showJump eq 1>
						
							<td width="20" class="labelit" style="padding-left:4px;padding-top:4px">
								<a href="javascript:calendarJumpTo();" style="color:6688aa;">
									<cf_tl id="Jump">
								</a>
							</td>
						</cfif>
						<cfif attributes.showToday eq 1>						
							<td width="20" class="labelit" style="padding-left:4px;padding-top:4px">
								<a href="javascript:calendarToday();" style="color:6688aa;">
									<cf_tl id="Today">
								</a>
							</td>
						</cfif>
					</tr>				
					</cfoutput>
					</table>
				</td>
				
			<cfelse>			
			
			<td align="center" width="90%" colspan="2">
					<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
					<cfoutput>
					<tr>						
						<td id="currentmonth" name="currentmonth" align="right" class="labelmedium" style="font-weight:normal;height:30px;padding:1px;font-size:19px;">
							#year(dateob)#								
						</td>						
					</tr>				
					</cfoutput>
					</table>
				</td>
						
			</cfif>
						
			</tr>
			
			<tr>						
				<td colspan="2">											
				  		
					<cf_securediv bind="url:#session.root#/tools/calendar/calendarView/CalendarViewMonthMenu.cfm?cellwidth=#attributes.cellwidth#&pdate=#dateFormat(dateob,client.dateFormatShow)#&showToday=#attributes.ShowToday#&showRefresh=#attributes.ShowRefresh#&ShowPrint=#attributes.ShowPrint#" id="divCalendarViewMonthMenu">					
					
				</td>
			</tr>
			
			</table>
			
			</td>
		
		</tr>		
		
		<cfparam name="url.fieldname"        default="#attributes.fieldname#">
		<cfparam name="url.pfunction"        default="#attributes.pfunction#">
		<cfparam name="url.relativepath"     default="#attributes.relativepath#">
		<cfparam name="url.preparation"      default="#attributes.preparation#">
	    <cfparam name="url.content"          default="#attributes.content#">
		<cfparam name="url.condition"        default="#attributes.condition#">
		<cfparam name="url.targetid"         default="#attributes.targetid#">		
		<cfparam name="url.target"           default="#attributes.target#">			
		<cfparam name="url.selecteddate"     default="#dateformat(attributes.selecteddate,CLIENT.DateFormatShow)#">									
		<cfparam name="url.cellw"            default="#attributes.cellwidth#">
		<cfparam name="url.cellh"            default="#attributes.cellheight#">		
		<cfparam name="url.daterange"        default="#attributes.DateRange#">		
		<cfparam name="url.isDisabled"       default="#attributes.isDisabled#">
		<cfparam name="url.scroll"           default="#attributes.scroll#">
		
		<!--- Session variable for long lists of valid dates --->
		<cfset SESSION.calendarViewValidDates = attributes.validDates>
		
		<cfset url.selecteddate = dateformat(dateob,CLIENT.DateFormatShow)>			
								
		<cfif attributes.mode eq "picker">
		
			<tr><td id="calendarcontent" valign="top" style="padding-top:1px" align="center" width="100%">				
				<cfinclude template="CalendarViewPicker.cfm">					 
			</td></tr>
		
		<cfelse>
						
			<cfif url.scroll eq "Yes">
							
			<tr><td valign="top" style="padding-top:7px;min-height:200px;" align="center" height="100%" width="100%">							
			
			    <cf_divscroll id="calendarcontent" style="min-height:200px">				   												
	    		<!--- details of the calendar fro this month --->
				<cfinclude template="CalendarViewContent.cfm"> 								  	
				</cf_divscroll>
				</td>
				
			</tr>	
				
			<cfelse>
			
			<tr><td valign="top" style="border:0px solid gray;padding-top:7px;min-height:200px" id="calendarcontent" align="center" height="#ht#" width="100%">	
				<cfinclude template="CalendarViewContent.cfm"> 								  	
				</td>
			</tr>
			
			</cfif>	
		 
	 
		</cfif>			
								
</table>

</div>

</cfoutput>
