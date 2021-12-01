
<cfparam name="attributes.name"             default="transaction_date">
<cfparam name="attributes.id"               default="">
<cfparam name="attributes.edit"             default="no">
<cfparam name="attributes.key1"             default="">
<cfparam name="attributes.key2"             default="">
<cfparam name="attributes.key3"             default="">
<cfparam name="attributes.key4"             default="">
<cfparam name="attributes.value"            default="">
<cfparam name="attributes.valuehour"        default="12">
<cfparam name="attributes.valueminu"        default="00">
<cfparam name="attributes.valuecontent"     default="">
<cfparam name="attributes.font"             default="16">
<cfparam name="attributes.timezone"         default="0">
<cfparam name="attributes.mode"             default="date">
<cfparam name="attributes.pFunctionSelect"  default="">
<cfparam name="attributes.pFunction"        default="">
<cfparam name="attributes.datevalidstart"   default="01011900">
<cfparam name="attributes.dialog"           default="">
<cfparam name="attributes.future"           default="No">
<cfparam name="attributes.class"            default="">
<cfparam name="attributes.jumpMinutes"      default="1">
<cfparam name="attributes.minHour"    	    default="0">
<cfparam name="attributes.maxHour"    	    default="23">

<cfif attributes.value eq "">

	<cfset dte = now()>
	<cfset dte = DateAdd("h", attributes.timezone, dte)>
	<cfset hr = "#timeformat(dte,'HH')#">
	<cfset mn = "#timeformat(dte,'MM')#">
	
<cfelseif attributes.valuecontent eq "datetime">

	<cfset dte = attributes.value>
	<cfset dte = DateAdd("h", attributes.timezone, dte)>
	<cfset hr = "#timeformat(dte,'HH')#">
	<cfset mn = "#timeformat(dte,'MM')#">	
		
<cfelse>

	<CF_DateConvert Value="#attributes.value#">
	<cfset dte = dateValue>	
	<cfset dte = DateAdd("h", 0, dte)>
	<cfset hr = "#attributes.valuehour#">
	<cfset mn = "#attributes.valueminu#">
	
</cfif>	

<cfset val = dateformat(dte,CLIENT.DateFormatShow)>

<cfset vDisplayClassUp = "hide">
<cfif attributes.future eq "Yes">
	<cfset vDisplayClassUp = "regular">
</cfif>

<cfoutput>

<table cellspacing="0" cellpadding="0">
				
	<tr>
	
		<cf_assignid>
				
		<cfif attributes.id eq "">
			<cfset myid = left(rowguid,8)>
		<cfelse>
		    <cfset myid = attributes.id>
		</cfif>	
	
		<cfif attributes.mode eq "datetime" or attributes.mode eq "date">
				
			<td>
				
						
			<cfif attributes.dialog neq "Yes">
						
			<table cellspacing="0" cellpadding="0">
			
				<tr>					
				
				<td id="datecheck" class="hide"></td>
				
				<td style="padding-right:3px">
																
				<cfset width = (attributes.font+10) * 4.2>
																			
				<cfif attributes.edit eq "Yes">
										
					<input type="text" 
				     name     = "#attributes.name#_date"
				     id       = "#myid#_date" 
					 style    = "padding-left:5px;padding-right:5px;padding-top:1px;font-size:#attributes.font#px;height:#attributes.font+12#;width:#width#;text-align:center" 
					 class    = "#attributes.class# enterastab"
					 onchange = "ptoken.navigate('#SESSION.root#/tools/calendar/DateChange.cfm?key1=#attributes.key1#&key2=#attributes.key2#&key3=#attributes.key3#&key4=#attributes.key4#&datevalidstart=#attributes.datevalidstart#&future=#attributes.future#&function=#attributes.pfunction#&name=#myid#&value='+this.value+'&increment=0','#attributes.name#_datebox')"
					 onblur   = "ptoken.navigate('#session.root#/tools/Calendar/setCalendarDateCheck.cfm?name=#myid#&val='+this.value,'datecheck')" 
					 value    = "#val#">								
					 
				<cfelse>
				
					<input type="text" 
				     name  = "#attributes.name#_date"
				     id    = "#myid#_date" 
					 style = "padding-left:5px;padding-right:5px;border:1px solid silver;padding-top:1px;font-size:#attributes.font#px;height:#attributes.font+10#;width:#width#;text-align:center" 
					 class = "#attributes.class# enterastab" 
					 readonly value="#val#">				
				
				</cfif>	 				 
						 
				</td>
				
				<td style="padding-top:3px;padding-bottom:3px">			
							
				<table border="0" cellspacing="0" style="border:1px solid silver;height:#attributes.font+12#" cellpadding="0" bgcolor="e7e7e7">
				
					<tr class="#vDisplayClassUp#" id="#myid#_date_datenext_tr">
					
					<td align="center" style="padding-top:0px;padding-bottom:0px;border-radius:1px;border-bottom:1px solid silver;padding-left:6px;cursor:pointer;padding-right:6px;" 
					onclick="ptoken.navigate('#SESSION.root#/tools/calendar/DateChange.cfm?key1=#attributes.key1#&key2=#attributes.key2#&key3=#attributes.key3#&key4=#attributes.key4#&datevalidstart=#attributes.datevalidstart#&future=#attributes.future#&function=#attributes.pfunction#&name=#myid#&value='+document.getElementById('#myid#_date').value+'&increment=1','#attributes.name#_datebox')">
										
						<img src="#SESSION.root#/images/up6.png" 
							 id="#myid#_date_datenext" 
							 width="8" 
							 height="#(attributes.font)/2#" 
							 alt="" 
							 border="0">
							 
					</td>
					</tr>
					
					<!--- the buttom to go previous date --->					
					<CF_DateConvert Value="#attributes.datevalidstart#">
					<cfset start = dateValue>	
					<cfif start lt dte or attributes.future eq "Yes">
						<cfset vDisplayClassDown = "regular">
					<cfelse>
						<cfset vDisplayClassDown = "hide">	
					</cfif>		
													
					<tr class="#vDisplayClassDown#" id="#myid#_date_dateprior_tr">
					<td align="center" style="padding-left:6px;padding-top:0px;padding-bottom:0px;cursor:pointer;padding-right:6px;"
					 onclick="ptoken.navigate('#SESSION.root#/tools/calendar/DateChange.cfm?key1=#attributes.key1#&key2=#attributes.key2#&key3=#attributes.key3#&key4=#attributes.key4#&datevalidstart=#attributes.datevalidstart#&future=#attributes.future#&function=#attributes.pfunction#&name=#myid#&value='+document.getElementById('#myid#_date').value+'&increment=-1','#attributes.name#_datebox')">
					 				
						<img src="#SESSION.root#/images/down6.png" 
							id="#myid#_date_dateprior" 
							width="8" 
							height="#(attributes.font)/2#" 			
							border="0">					
							
					</td>
					</tr>
											
				</table>
				</td>
				</tr>
				
				<tr class="hide"><td id="#attributes.name#_datebox"></td></tr>			
			
			</table>	
							
			</td>
			
			<cfelse>
			
			<td class="fixlength">	
																		
				<cfif attributes.future eq "No">
																			
					<cf_intelliCalendarDate9
							FieldName="#attributes.name#_date" 
							Id="#myid#_date"							
							Manual="True"		
							class="regularxl"							
							DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"
							Default="#val#"
							script="#attributes.pfunction#"
							scriptdate="#attributes.pfunctionselect#"
							AllowBlank="False">	
							
							
				<cfelse>				
																				
					<cf_intelliCalendarDate9
							FieldName="#attributes.name#_date" 
							Id="#myid#_date"							
							Manual="True"		
							class="regularxl"															
							Default="#val#"
							script="#attributes.pfunction#"
							scriptdate="#attributes.pfunctionselect#"
							AllowBlank="False">	
							
														
							<!--- DateValidStart="#Dateformat(now(), 'YYYYMMDD')#" --->
				
				</cfif>			
			
			</td>
			</cfif>
			
			<cfif attributes.mode eq "datetime" or attributes.mode eq "time">
			
			<td style="padding-left:5px;padding-right:5px">@</td>	
			
			</cfif>
			
		<cfelse>	
		
			<input type="hidden" 
				     name  = "#attributes.name#_date"
				     id    = "#myid#_date" 
					 value="#val#">	
		
		</cfif>
		
		<cfif attributes.mode eq "datetime" or attributes.mode eq "time">
		
					
			<td>	
																				
				<select name	 = "#attributes.name#_hour" 
						id		 = "#attributes.name#_hour" 
						class    = "enterastab #attributes.class#"
						onchange = "#attributes.pfunction#(document.getElementById('#attributes.name#_date').value, this.value,document.getElementById('#attributes.name#_minute').value,'#attributes.key1#','#attributes.key2#','#attributes.key3#','#attributes.key4#')"					
						style    = "border-radius:1px;width:50;font-size:#attributes.font#px;height:#attributes.font+10#">
				
					<cfloop index="it" from="#attributes.minHour#" to="#attributes.maxHour#" step="1">
					
						<cfif it lte "9">
						    <cfset it = "0#it#">
						</cfif>				 
						
						<option value="#it#" <cfif hr eq it>selected</cfif>>#it#</option>
					
					</cfloop>	
					
				</select>	
								
			</td>			
			<td>:</td>			
			<td>
						
				<select name	= "#attributes.name#_minute" 
						id		= "#attributes.name#_minute" 
						class   = "enterastab #attributes.class#" 
						onchange = "#attributes.pfunction#(document.getElementById('#attributes.name#_date').value,document.getElementById('#attributes.name#_hour').value,this.value,'#attributes.key1#','#attributes.key2#','#attributes.key3#','#attributes.key4#')"	
						style	= "border-radius:1px;width:50;font-size:#attributes.font#px;height:#attributes.font+10#">
			
					<cfloop index="it" from="0" to="59" step="#attributes.jumpMinutes#">
					
						<cfif it lte "9">
						  <cfset it = "0#it#">
						</cfif>				 
						
						<option value="#it#" <cfif mn eq it>selected</cfif>>#it#</option>
					
					</cfloop>	
							
				</select>	
			
			</td>
		
		</cfif>			
	</tr>		
</table>
</cfoutput>	
