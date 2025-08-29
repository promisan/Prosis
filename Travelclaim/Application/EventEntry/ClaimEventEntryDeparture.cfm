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
<script language="JavaScript">

function ref(val,stop,box) {

se1 = document.getElementById("ref1_"+stop)
se2 = document.getElementById("ref2_"+stop)

ColdFusion.navigate('ClaimEventEntryPointer.cfm?code='+val+'&box='+box,'ajax')

if (val == "Air") {
	se1.className = "regular"
	se2.className = "regular"
} else {
	se1.className = "hide"
	se2.className = "hide"
}

}

<!-- Original:  Cyanide_7 (dev@email) -->
<!-- Web Site:  http://members.xoom.com/cyanide_7 -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var isNN = (navigator.appName.indexOf("Netscape")!=-1);

function autoTab(input,len, e) {
	var keyCode = (isNN) ? e.which : e.keyCode; 
	var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
	if(input.value.length >= len && !containsElement(filter,keyCode)) {
	input.value = input.value.slice(0, len);
	input.form[(getIndex(input)+1) % input.form.length].focus();
	}
	function containsElement(arr, ele) {
	var found = false, index = 0;
	while(!found && index < arr.length)
	if(arr[index] == ele)
	found = true;
	else
	index++;
	return found;
	}
	function getIndex(input) {
	var index = -1, i = 0, found = false;
	while (i < input.form.length && index == -1)
	if (input.form[i] == input)index = i;
	else i++;
	return index;
	}
	return true;
}
//  End -->	


</script>

<cfquery name="TripDeparture" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
    FROM  ClaimEventTrip T,  
	      ClaimEvent E,
	      System.dbo.Ref_Nation R
    WHERE T.ClaimEventId = '#URL.ID1#'
	AND   E.ClaimEventId = E.ClaimEventId
	AND   T.ClaimEventId = E.ClaimEventId
	AND   T.LocationCountry *= R.Code
	AND   T.ClaimTripMode = 'Departure'
	AND   T.ClaimTripStop = '#stopover#'  
	ORDER BY LocationDate 
</cfquery>	

<cfquery name="PriorTrip" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   ClaimEventTrip CE, ClaimEvent C
	WHERE  CE.ClaimEventId = C.ClaimEventId
	AND    C.ClaimId = '#URL.ClaimId#'
	ORDER BY LocationDate DESC
</cfquery>	

<cfquery name="TripRequest" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
    FROM ClaimRequestItinerary 
    WHERE ClaimRequestId = '#Claim.ClaimRequestId#'
	ORDER BY DateDeparture
</cfquery>	

<cfset tripid = '#TripDeparture.ClaimTripId#'>

<cfoutput>

<table width="100%" border="0" cellspacing="2" cellpadding="2">

			<tr class="hide"><td id="ajax"></td></tr>

          	<tr>
				<td colspan="2">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td height="19" align="left">&nbsp;<b>Departure</b></td>
						<td align="right">						
						&nbsp;
						</td>
					</tr>
					</table>
				</td>
			</tr>
			<tr><td height="1" colspan="4" bgcolor="C0C0C0"></td></tr>		
			
			<cfset box = 1>
			
			<tr>
				<td height="28" width="65" align="right">&nbsp;Mode:&nbsp;</td>	
				<td>
				<select name="EventCode" onChange="ref(this.value,'#stopover#','pointer#box#')">
					<cfloop query="TravelMode">
				    <option value="#code#" <cfif Code eq "#TripDeparture.EventCode#">selected</cfif>>#Description#</option>
					</cfloop>
				</select>
				</td>
			</tr>					
											
			<tr>
				<td height="28" width="65" align="right">&nbsp;City:&nbsp;</td>
			
				<td height="20">
				
				<table width="100%" bordercolor="97A8BB" border="0">
				
					<tr>
					
					<td width="20" align="center">
					
					  <button class="button3" style="height:20"
					          onClick="selectcity('depcityid','#tripdeparture.claimtripid#')">
							  
						   <img src="#SESSION.root#/Images/locate.gif" 
						    onMouseOver="document.img1.src='#SESSION.root#/Images/locate.gif'"
	     					onMouseOut="document.img1.src='#SESSION.root#/Images/locate.gif'"
							id      = "img1"
							name    = "img1"
						    alt     = "Search" 
						    border  = "0" 
						  
						    align   = "absmiddle" 
						    style   = "cursor: hand;">
							
					  </button>
					  
					 			
					</td>
					
					<td>					
										
					    <cfdiv id="depcityid_fld" 
						bind="url:ClaimEventEntryCity.cfm?claimtripid=#tripdeparture.claimtripid#&fld=depcityid&cityid=#tripdeparture.countrycityid#"/>						
						
												   
					</td>		   
					
					<td>
					
					<cfinput type="text" style="width:1px"						       
						   name="depcityid"  
						   required="Yes"
						   Message="Please select a departure location"
						   value="#Tripdeparture.CountryCityId#">	
					</td>
					
					</tr>
					
				</table>
		
				</td>		
				
			</tr>
			
			<tr>
				<td height="20" align="right">&nbsp;Date:</td>
				<td>
				<table border="0" cellspacing="0" cellpadding="0">
				<tr><td width="120">
								
				    <script language="JavaScript">

					function syncdate() {
					
					try {
					dep = document.getElementById("DepartureDate")
					dte = document.getElementById("DateArrival_0")
					dte.value = dep.value
					} catch(e) {}
					
					}

					</script>
					
													
				    <cfif TripDeparture.recordcount eq "0">
					
					    <cfif PriorTrip.LocationDate neq "">
					
						 <cf_intelliCalendarDate7
						FieldName="DepartureDate" 
						Default="#Dateformat(PriorTrip.LocationDate+1, CLIENT.DateFormatShow)#"
						AllowBlank="False"						
						DateScript="true"
						Mask="true">	
						
						<cfset dd = "#Dateformat(PriorTrip.LocationDate+1, CLIENT.DateFormatShow)#"> 
						
						<cfelse>
						
							 <cf_intelliCalendarDate7
						FieldName="DepartureDate" 
						Default="#Dateformat(TripRequest.DateDeparture, CLIENT.DateFormatShow)#"
						AllowBlank="False"
						DateScript="true"
						Mask="true">	
						
						<cfset dd = ""> 
											
						</cfif>
											
					<cfelse>
					
						 <cf_intelliCalendarDate7
						FieldName="DepartureDate" 
						Default="#Dateformat(TripDeparture.LocationDate, CLIENT.DateFormatShow)#"
						AllowBlank="False"
						DateScript="true"
						Mask="true">	
						
						<cfset dd = "">
											
					</cfif>
					
				<cfset thr  = #Timeformat(TripDeparture.LocationDate, "HH")#>
				<cfset tmin = #Timeformat(TripDeparture.LocationDate, "MM")#>	
				
				<cfif #TripDeparture.ActionStatus# eq "0">
					<cfset thr = "">
					<cfset tmin = "">
				</cfif>
					
				</td>
				<td height="25">&nbsp;Time:&nbsp;&nbsp;</td>
				<td align="center">
				
				<script language="JavaScript">
				
				function addhour(fld,val)
				
				{
				if (val == "23")
				{ val = 0 }
				else
				{val = val+1}
				
				alert(val)
				
				}
				
				</script>
				
								
				<cfinput type = "Text"
			       name       = "DepartureHour"
			       value      = "#thr#"
			       message    = "Please enter time using 24 hour format"
			       validate   = "regular_expression"
			       pattern    = "[0-1][0-9]|[2][0-3]"
			       visible    = "Yes"
			       enabled    = "Yes"
				   required   = "Yes"
			       size       = "1"
				   onKeyUp    = "return autoTab(this, 2, event);"
			       maxlength  = "2"
				   style      = "text-align: center;width:25"
			       class      = "regular">
										 				
				</td>
				<TD align="center">:</TD>
				<td align="center">
								
				<cfinput type="Text"
			       name      = "DepartureMinute"
			       value     = "#tmin#"
			       message   = "Please enter a departure minute between 00 and 59"
			       validate  = "regular_expression"
			       pattern   = "[0-5][0-9]"
			       required  = "Yes"
			       size      = "1"
				   maxlength = "2"
			       style     ="text-align: center;width:25"
			       class="regular">				   
																
				</td>
				<td width="10">
				 <cf_helpfile 
					   code = "TravelClaim" 
			           id   = "2">
				</td>			
			    <td height="25">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" bgcolor="white">
				
				
				<cfquery name="Event" 
					datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM Ref_ClaimEvent
					WHERE Code = '#tripdeparture.EventCode#'   
				</cfquery>	
				
				<cfif event.pointertransport eq "1">
				   <cfset m = "hide">
				<cfelse>
				   <cfset m = "regular">  
				</cfif>
												
				<tr><td width="60%" class="#m#" id="pointer#box#">					  
				
				      <cf_ClaimEventEntryIndicatorPointer
										 Category = "'Departure'"
										 tripid   = "#TripDeparture.ClaimTripId#"
										 fld      = ""> 				  										
				</td>
				
				</tr>	
				
					</table>
					</td>
				</tr>		
								
				</table>
				</td>
			</tr>
			
			<cfif TripDeparture.EventCode eq "Air">
				  <cfset cla = "regular">
			<cfelse>
				  <cfset cla = "hide">
			</cfif>
			
			<tr><td width="65" class="#cla#" id="ref1_#stopover#" align="right">Flight&nbsp;No:&nbsp;</td>
				<td class="#cla#" id="ref2_#stopover#">
					<input type="text" name="EventReference"  value="#TripDeparture.EventReference#" size="10" class="regular" maxlength="10">
				</td>
			</tr>
			
			<cfset cla = "regular">
						
</table>

</cfoutput>		
			
