
<cfsilent>

	<proUsr>administrator</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes></proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	This template is the is the master template loaded for ITINERARY SECTION and the SUMMARY/REVIEW screen. 
	1. It contains a set of basic checkings if a user tries to open this template using a valid ClaimId (Browser issue).
	2. The template is loaded once the user selects detailed claim. When detailed claim is selected the database is populated with the events (travel itinerary) from the TVRQ. This initial populatation and repetitive verification is performed by the template ClaimEventInit.cfm . 
	The existance of the events which is the basis of capturing information is also verified.	
	</td></tr>
	</table>
	</proInfo>

</cfsilent>

<cfif url.claimid eq "">
	 <cf_message message="Operation aborted. Invalid URL.">
	 <cfabort>
</cfif>

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
    FROM Claim R
    WHERE ClaimId = '#URL.ClaimId#'
</cfquery>

<cfif claim.recordcount eq "0">
	 <cf_message message="Operation aborted. Invalid URL.">
	 <cfabort>
</cfif>

<cfparam name="URL.ClaimId" default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="URL.ID1" default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="pdf" default="0">
<cfparam name="url.section" default="">
<cfparam name="editclaim" default="1">

<cfoutput>

<cfif pdf eq "0">
	
		<cf_wait1 text="Please wait." flush="force" icon="circle">
		
		<SCRIPT LANGUAGE = "JavaScript">
		
		function pdf() {
		   window.open("../PDF/TravelClaim.cfm?#CGI.QUERY_STRING#","_blank","width=900,height=800")
		}   
		  
		function reloadForm(page) {
		    window.location="RecordListing.cfm?Page=" + page; 
		}
		
		function edit(id,event) {
		    window.location="ClaimEventEntry.cfm?Next=0&Section=#URL.Section#&Status=Edit&ClaimId=#Claim.ClaimId#&ID1=" + id + "&Topic="+event;
		}
		
		function calculate(enforce) {
		    window.location = "../Process/Calculation/Calculate.cfm?ClaimId=#URL.ClaimId#&Enforce="+enforce+"&Express=0"
		}
		
		function hotel() {
		    window.location = "ClaimEventEntryDSA.cfm?Next=0&Section=#URL.Section#&ClaimId=#URL.ClaimId#&ID1="
		}	
		
		function deleteevent(id2,id) {
			if (confirm("Do you want to remove this leg ?")) {
		     window.location = "ClaimEventPurge.cfm?id1=#URL.ClaimId#&id2="+id2+"&eventid="+id	
			}
			 false	
			}	
			
		</SCRIPT>	
		
		<div class="screen">

	</cfif>

</cfoutput>

<body leftmargin="5" topmargin="0" rightmargin="0" bottommargin="0">

<!--- prepopulate trip events from itin --->
<cfinclude template="ClaimEventInit.cfm">

<cfoutput>
	<link href="#SESSION.root#/#client.style#" rel="stylesheet" type="text/css">
	<link href="#SESSION.root#/print.css" rel="stylesheet" type="text/css" media="print">
</cfoutput>

<cfset enablenext = 1>
 	
<table width="99%" 
       height="100%" 
	   border="0" 
	   cellspacing="0" 
	   cellpadding="0" 
	   frame="hsides" 
<!---	   bordercolor="e4e4e4"  --->
	   align="center" 
	   bordercolor="#C0C0C0" 
	   bgcolor="#FFFFFF" 
	   rules="rows">
 
<tr><td height="6"></td></tr> 
	
<tr><td valign="top">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">

   <cfif URL.Topic eq 'Trip'>  
   		<!--- sumamry section --->
	    <cfset calc = "1">
		<cfset setNext = "0">		        				
   <cfelse>    
        <!--- itinerary section --->      
	  	<cfset calc = "0">
		<cfset setNext = "1">				
   </cfif>
   
   <!--- option to define if a user may remove a leg in the itinerary screen. The option to remove a leg is only relevant of there are several lines in the claim event that were created through different TVRQ lines. 
   The usual scenario is that the TVRQ contains a additional travel line because a user is continuing his travels for example through
   a SFT from an intermediate location, EO's sometime repeat the legs which caused the TCP to initial create too many legs. The user is 
   allowed to remove legs here
   --->
    
    <cfquery name="check" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT RecordReference
    FROM   ClaimEvent C
    WHERE  ClaimId = '#URL.ClaimId#' 	
	</cfquery>		
	
	<cfif check.recordcount gte "2">
	 <cfset allowdelete = 1>
	<cfelse>
	 <cfset allowdelete = 0> 
	</cfif>
			
	<cfquery name="Events" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     ClaimEvent C
    WHERE    ClaimId = '#URL.ClaimId#' 
	ORDER BY EventOrder, EventDateEffective, EventReference 
	</cfquery>		
		
	<cfset cnt = 0>
								
	<cfif Events.recordcount neq "0">		
		
		<tr>
		  <td colspan="4" height="30" class="noprint">
		 	  
		  <table width="99%" height="100%" cellspacing="0" cellpadding="0">
		 		  
		  <tr><td colspan="2">
		  		  
		  <cfinclude template="ClaimPreparation.cfm">
		  
		  </td></tr>
		  			
				<tr>				
				<cfif URL.Topic eq "Trip">									
				<td>
				
				<table cellspacing="0" cellpadding="0"><tr>
												
				<td height="32">
					&nbsp;						
					<font face="Verdana" 
				      color="gray"
					  size="4">
					  <b>Travel Claim Summary</font></b>
				    &nbsp;
				</td>
				
				<td>
				
				 <button class="button3" onClick="javascript:pdf()">
				 <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/pdf_button.png"
				     alt="Prepare PDF"
				     border="0"
					 class="noprint"
					 align="absmiddle"
				     style="cursor: hand;">
					<font color="808080">
				 </button>
				 &nbsp;
				 
				 </td>
				 
				 <td></td>
				 
				 </tr>
								 
				 <!--- do only recalculate if claim is edit status and not workflow defined --->
				 
				 <cfif (claim.actionStatus lte "1" and editclaim eq "1")>
				 <tr><td colspan="4">
									
					<font color="gray">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Please review Your Travel Claim. 
					
					 &nbsp; When your are finished press button : <b>Calculate Claim</b>
										 
					 <cfset setNext = 0>
					 
					 <!--- only if changes were effected in DSA and/or costs will this limitated 
					 calculation portion fire --->
					 
					 <cfif Object.recordcount eq "0">
		  								 
						 <cfif pdf eq "0">
						 
							<cfset url.validation = 0>
							<cfinclude template="../Process/Calculation/Calculate.cfm">
							
						 </cfif>							 
										 
					 </cfif>
				   </td></tr>	
				   
				   <tr><td height="3"></td></tr> 
				 
				  </cfif>	
								
				 </table>
					 
				</td>	
				</tr> 
												
				<cfelse>					
				
					<tr  ><td height="23">	
					<table border="0" cellspacing="0" cellpadding="0">
					<tr>
					<td width="25"><cfoutput><img src="#SESSION.root#/Images/join.gif" alt="" border="0"></cfoutput></td>
					<td height="25">				
					<font face="Verdana" size="2"><b>Itinerary
					</td>
					<td width="4"></td>
					<td height="25" align="left">
					<cf_helpfile code       = "TravelClaim" 
							    id          = "Itin" 
								display     = "Icon"	
								color       = "006688">
								<!--- displayText = "Incorrect Itinerary"	--->
					</td>
					</tr>
					</table>
					
					<cfif claim.actionstatus lte "1">
					
						<cfquery name="Section" 
							datasource="AppsTravelClaim">
							SELECT   *
							FROM     #CLIENT.LanPrefix#Ref_ClaimSection 
							WHERE    Code = '#Section#' 
						</cfquery>
						
						<cfoutput>
						<tr><td height="1" bgcolor="C0C0C0"></td></tr>
						<tr>
							    <td align="center">
								<table width="100%">
								<tr><td width="40">																	
									<img src="#SESSION.root#/Images/finger.gif" 
											alt="Show"  
											id="#Category#Exp" border="0" 
											align="middle">		
											
									</td>
								    <td>#Section.DescriptionTooltip#&nbsp;</td>				
								</tr>
								</table>
								</td>
						</tr>	
						<tr><td height="1" colspan="2" bgcolor="c0c0c0"></td></tr>
		
						</cfoutput>	
						
					</cfif>		
					
				</cfif>	
		
		<tr><td height="3"></td></tr>
		
		</table>
		
		</td>
		</tr>	
		
		<tr><td colspan="4" valign="top">
		
		<!---
		<cfif URL.Topic eq "Trip">
		   <cf_tabletop size="98%">  
		</cfif>   
		--->
						
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="C0C0C0" rules="rows">
		
		<cfif URL.Topic eq "Trip">	
			
			<tr><td colspan="9">
			<cf_summaryheader name="Itinerary">		
			</td></tr>
			
		</cfif>	
		
	</cfif>
	
	<!--- check if the events are in order --->
		
	<cfoutput query="Events">
	
		<cfif currentrow eq "1">
		  <cfset pr = eventDateEffective>
		<cfelse>
			<cfif eventDateEffective lt pr>
				
				<tr><td colspan="9" height="25" bgcolor="red" align="center"><b>
				<cfset ana = "Problem:</b> Submitted Itinerary dates do not follow the sequence as defined in the travel request">
				<cfset setnext = "0"> 
				<cfset error = "1"> 
				<font color="FFFFFF">#ana#</font>
				</td></tr>
			
			</cfif>
		</cfif>
		
	</cfoutput>
			
    <cfparam name="URL.ID1" default="">
	
	<cfoutput query="Events">
	
	    <cfset mode = "">
		<cfset error = "">
	
		<cfif URL.ID1 eq ClaimEventId>
		    <cfset cl = "ffffff">
			<cfset edit = "0">			
		<cfelse>
		    <cfset cl = "ffffff">
			<cfset edit = "1">
		</cfif>
		
		<tr><td height="4"></td></tr>
		
		<cfif URL.Topic neq "Trip">	
		
		<tr bgcolor="#cl#">
		  
		    <td colspan="8">
						
			<cfquery name="Trip" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
			    FROM  ClaimEventTrip T
			    WHERE ClaimEventId = '#ClaimEventId#'
				AND   T.ClaimTripStop = 0
				<cfif Parameter.EnableGMTTime eq "0"> 
				ORDER BY LocationDate, EventCode  
				<cfelse>
				ORDER BY LocationDateGMT, EventCode 
				</cfif>
				
			</cfquery>
			
			 <table width="275" border="0" cellspacing="0" cellpadding="0">
			 	<tr>
				<td width="100%">
				<table width="260" cellspacing="1" cellpadding="1" bgcolor="DFEFFF" 
				style="border-left: 1px solid silver; border-top: 1px solid silver; border-right: 1px solid silver;">
				   <tr>
				   <cfif claim.actionStatus lte "1" and URL.Topic neq "Trip" and editclaim eq "1">	
				   <td width="16" align="center">
				 		<img src="#SESSION.root#/Images/pointer.gif" 
						border="0" 
						align="absmiddle" 
						alt="Edit" 
						onClick="javascript:edit('#ClaimEventId#','Trip')">
					
				   </td>
				   </cfif> 		 
				  
				  <td>
				  
				  <cfif claim.actionStatus lte "1" and URL.Topic neq "Trip" and editclaim eq "1">
				 
				    <a href="javascript:edit('#ClaimEventId#','Trip')" alt="Edit">
					  <b><font color="black">Edit:</b>
					    <font color="0080C0">
					    <cfloop query="trip">
						#LocationCity# 
						<cfif CurrentRow eq "1"> to </cfif>						
					</cfloop>
					</a>
				  <cfelse>
				   <cfloop query="trip">
						#LocationCity# 
						<cfif CurrentRow eq "1"> to </cfif>
					</cfloop> 
				  </cfif>
				  
				  </td>
				  				  
				  <td width="20" align="right">
				  <cfif allowdelete eq "1" and editclaim eq "1">
					  <img name="img2_#currentrow#" 
					  src="#SESSION.root#/Images/close-off.gif" align="absmiddle" alt="Remove leg" border="0"
					  style="cursor:hand" onclick="deleteevent('','#claimeventid#')"
					  onMouseOver= "document.img2_#currentrow#.src='#SESSION.root#/Images/close-on.gif'" 
					  onMouseOut = "document.img2_#currentrow#.src='#SESSION.root#/Images/close-off.gif'"
					  >
				  </cfif>
				  
				  </td>
				  								  
				  </tr>
			    </table>
			    </td></tr>  
			</table>
									
			</td>
				
		</tr>
		
		</cfif>
		
		<!--- ---------- --->
		<!--- travellers --->
		<!--- ---------- --->
					
			<cfquery name="EventPerson" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT P.IndexNo, 
				       P.LastName, 
					   P.FirstName, 
					   P.Gender, 
					   P.Nationality
			    FROM   ClaimEventPerson C, 
				       stPerson P
			    WHERE  ClaimEventId = '#ClaimEventId#'
				AND    C.PersonNo = P.PersonNo
				
			</cfquery>
			
			<cfif EventPerson.recordcount gte "2">
			<tr bgcolor="f9f9f9"><td bgcolor="white"></td>
			    <td colspan="7">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				<cfloop query="EventPerson">
				<tr>
				<td height="18" width="70">Traveller:</td>
				<td><font color="0066CC">#FirstName# #LastName# (#Gender#)</font></b></td>
				<td width="70">IndexNo:</td>
				<td><font color="0066CC">#IndexNo#</font></b></td>
				</tr>
				<cfif #currentRow# neq "#Recordcount#">
				<tr><td height="1" colspan="4" bgcolor="D7D7D7"></td></tr>
				</cfif>
				</cfloop>
				</table>
				</td>
			</tr>
			</cfif>
			
		<!--- ---------- --->
		<!--- legs -     --->
		<!--- ---------- --->	
								
		<cfquery name="Trip" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *, 
			       CASE WHEN  LocationDateGMT is NULL  
				        THEN  LocationDate   
						ELSE  LocationDateGMT  
						END  as LocationDateTime
		    FROM   ClaimEventTrip T, 
			       System.dbo.Ref_Nation N,
				   Ref_ClaimEvent R
		    WHERE  ClaimEventId = '#ClaimEventId#'
			AND    T.EventCode = R.Code
			AND    T.LocationCountry *= N.Code			
			<cfif Parameter.EnableGMTTime eq "0"> 
			ORDER BY LocationDate, EventCode  
			<cfelse>
			ORDER BY LocationDateGMT, EventCode 
			</cfif>
		</cfquery>
		
		<!--- loop through this result set and determine problems first --->
		
		<cfset ana = arrayNew(1)>
		<cfset prior = "">
				
		<cfloop query="Trip">
				
			<cfif #ClaimTripMode# eq "Departure"
					   and #ClaimTripStop# eq "0"
					   and #CurrentRow# neq "1">
					 
				<cfset ana[#currentRow#] = "Departure date/time lies after the arrival date/time.">
				<cfset setnext = "0"> 
				<cfset error = "1"> 

			<cfelseif #ClaimTripMode# eq "Arrival"
				  and #ClaimTripStop# eq "0"
				  and #CurrentRow# neq #Recordcount#>
				
				  <cfset setnext = "0"> 
				  <cfset error = "1">
					
				 <cfset ana[#currentRow#] = "Return date/time has not been correctly defined.">
				 
			<cfelseif #Prior# eq "#ClaimTripMode#" 
					 and #ClaimTripStop# neq "0">
						  <cfset setnext = "0">
						  <cfset cl = "FF0000">
						  <cfset clb = "FDDFDB">

				 <cfset ana[#currentRow#] = "Stopover departure appears to be incorrect.">
				 <cfset setnext = "0"> 
				 <cfset error = "1">
				 
			</cfif>
			
			<cfset prior = "#ClaimTripMode#">
		
		</cfloop>
						
		<cfif error eq "1">
			
			<cfset cl = "red">				
			<tr>
			
			<td colspan="9">
			<table width="100%" bordercolor="silver" border="0" cellspacing="0" cellpadding="0">	
			<tr><td colspan="2" align="center">
			<img src="#SESSION.root#/Images/error.gif" alt="" width="50" height="50" border="0">
			</td></tr>
			<tr><td colspan="2" align="center" height="20" bgcolor="DF7000">
			<font color="FFFFFF">
			<b>&nbsp;The below submitted itinerary is INCORRECT</td></tr>	
			
			<cfset enablenext = 0>
						
			<cfloop query="Trip">
			
			<cfparam name="ana[currentRow]" default="">
			
				<cfif ana[currentRow] neq "">
				    <tr><td bgcolor="d3d3d3" height="1" colspan="2"></td></tr>
					<tr bgcolor="ffffbf">
					<td height="20" width="40"></td>
					<td>Line #currentRow# : #ana[currentRow]#</td></tr>
					
				</cfif>
			
			</cfloop>
			
			<cfif Claim.ActionStatus lt "3" and edit eq "1">
			
				<tr><td colspan="2" bgcolor="C0C0C0"></td>
				<tr><td colspan="2" align="center">
				
				<img src="#SESSION.root#/Images/finger.gif"
						     alt="Attention"
						     border="0"
						     align="absmiddle"
						     style="cursor: hand;">
							 
				<a title="Correct itinerary" href="javascript:edit('#ClaimEventId#','Trip')">
					<b><font color="0080FF">Click here to correct the itinerary</b>
				</a>
				</td></tr>
			
			</cfif>
			
			</table>
			</td></tr>
			
		<cfelse>
		
			<cfparam name="ana[currentRow]" default="">
		
		</cfif>
						
		<!--- show the result and combine the errors in one screen --->
								
		<cfif Trip.recordcount neq "0">						
			
			<!--- hidden 10/6 to make screen more queit --->
			
			<cfif currentrow eq "1" or url.topic neq "trip">
			
				<cfif url.topic neq "trip">
					<tr><td colspan="9" bgcolor="C0C0C0"></td></tr>
				</cfif>
									
				<tr>
				  <td width="12%" align="center" style="border-left: 0px silver solid;">&nbsp;<b>
				  <cfif url.topic neq "Trip">Travel Mode</cfif></td>
				  <td width="70"></td>
				  <td width="25%"><b>City</td>
				  <td width="20%"><b>Country</td>
				  <td width="90"></td>
		   		  <td width="80"><b>Date</td>
			      <td width="60"><b>Time</td>
				  <td width="120" colspan="2" style="border-right: 0px silver solid;" align="right">
				  <cfif url.topic eq "Trip"><b>Terminal</cfif></td>				 
				</tr>
			
			</cfif>
					
		        <cfset m = "0">
				<cfset prior = "">
				<cfset pr = now()>
				<cfset GMTD = "">
				<cfset GMTA = "">
																
				<cfloop query="trip">
				
					<cfif ClaimTripMode eq "Departure">
						<tr><td bgcolor="silver" class="noprint" height="1" colspan="9"></td></tr>
					</cfif>
				
					<cfif claimtripdate neq prior>
							<cfset prior = claimtripdate>
					</cfif>
				
					<cfparam name="ana[currentRow]" default="">
				
				   <cfif ana[currentRow] eq "">
			 		<cfset cl = "black">
				   <cfelse>
			   	    <cfset cl = "red"> 
				   </cfif>
				   
					<cfquery name="Indicator" 
							datasource="appsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   I.*, T.IndicatorValue, T.ClaimEventId, T.ClaimTripId
							FROM     ClaimEventTripIndicator T INNER JOIN
				                     Ref_Indicator I ON T.IndicatorCode = I.Code
							WHERE T.ClaimTripId = '#ClaimTripId#'
							AND   I.Category IN ('Arrival','Departure')
					</cfquery>
									   
				   <tr>
										
							<cfif ClaimTripMode eq "Departure">
							
								<td align="center" rowspan="#2+Indicator.recordcount#">
										
								<cfset mode = "#EventCode#">
								
								   <cfif Image neq "">&nbsp;
								   <img src="#SESSION.root#/Images/claim/#image#" align="absmiddle" alt="" border="0">
								   </cfif>
								   <cfif Claim.ActionStatus lt "3" and edit eq "1">
								   <a href="javascript:edit('#ClaimEventId#','Trip')">
								   </cfif>
								   &nbsp;#Description#
								   </a>		
								   
								 </td>  				  
													
							</cfif>
											
						    <td height="18" align="right"><font color="4E6FBA">
							<cfif ClaimTripStop neq "0">
							#left(ClaimTripMode,1)#
							<cfelse>
							#left(ClaimTripMode,3)#:
							</cfif>
							&nbsp;
							</td>
							
							<cfif url.topic eq "Trip">
							 <cfset ht = 10>
							<cfelse>
							 <cfset ht = 27>
							</cfif>
							
							<td height="#ht#">
							<table border="0" cellspacing="0" cellpadding="0">
							<tr><td><font color="#cl#">#LocationCity#</td></tr>
							<cfloop query="Indicator">
							<tr>
							<td><font size="1" color="gray">- #Description# <cfif #IndicatorValue# neq "1">#IndicatorValue#</cfif></font></td>
							</tr>		
							</cfloop>	
							</table>													
							</td>
							<td colspan="1"><font color="#cl#">#Name#</td>							
							<td>
							<!---
							<cfif OvernightStay eq "1">Overnight&nbsp;</cfif>
							--->
							</td>
							
							<td><font color="#cl#">#DateFormat(LocationDate, CLIENT.DateFormatShow)#</td>
							<td nowrap><font color="#cl# "> 

							    <cfif Claim.ClaimAsIs eq "1">
									<!--- not required --->
							    <cfelseif #ActionStatus# eq "0">
								<a href="javascript:edit('#ClaimEventId#','Trip')" title="You must enter a valid date/time for this location"><font color="FF0000">
								<b>Required</b></font>
								</a>
								<cfset setnext = "0">
								<cfelse>
								
									<cfset gmtD = gmta>
																	
									<cfif LocationDateGMT neq "">
										
										<cfset gmth = DateDiff("h", "#LocationDate#", "#LocationDateGMT#")>
										<cfset gmtn = DateDiff("n", "#LocationDate#", "#LocationDateGMT#")>						
										
										<cfset gmtA = "#LocationDateGMT#"> 
										
										#TimeFormat(LocationDate, 'HH:MM')# (GMT<cfif #gmth# gte "0">+</cfif>#gmth# 
										
										<!--- <cfif #gmtn# neq "">#gmtn#</cfif> --->
										
										)
									
									<cfelse>
									
										<cfset gmtA = ""> 
										#TimeFormat(LocationDate, 'HH:MM')# 
									
									</cfif>	
																											
								</cfif>
							</td>
							<td>
							
							<!--- temp measure only, can be remove in future 06/06/2008 --->
							
							<cfif ClaimTripMode eq "Arrival" and ClaimTripStop eq "0">
							
							    <cfquery name="Reset" 
										datasource="appsTravelClaim" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										UPDATE ClaimEventTrip
										SET EventCode = (SELECT TOP 1 EventCode 
										                 FROM  ClaimEventTrip 
														 WHERE ClaimTripId <> '#ClaimTripId#'
														 AND   ClaimEventId = '#ClaimEventId#'
														 ORDER BY LocationDate DESC)
										WHERE ClaimTripId = '#ClaimTripId#'  
								 </cfquery>						
							
							</cfif>
														
							
							<cfif #ClaimTripMode# eq "Arrival" and #ActionStatus# neq "0">
								
								<cfif #LocationDateGMT# neq "" and #gmtD# neq "">
								
									<cfset durH = DateDiff("h", "#gmtD#", "#LocationDateGMT#")>
								    <cfset durM = DateDiff("n", "#gmtD#", "#LocationDateGMT#")>
																		
									 #durH# hr #durM# min 
																	
								</cfif>
								
							<cfelse>
							
							    <cfset pr = #LocationDate#>	
																								
							</cfif>
								
							</td>
							<td align="right">
							
							<cfif url.topic eq "Trip">
							<table cellspacing="0" cellpadding="0">
							
								 <cfquery name="Cost" 
										datasource="appsTravelClaim" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT     CI.Description, CI.Reference, CI.InvoiceCurrency, CI.InvoiceAmount
										FROM         ClaimEventIndicatorCost CI INNER JOIN
							                      Ref_Indicator R ON CI.IndicatorCode = R.Code
										WHERE ReferenceId = '#claimTripId#'		  
								 </cfquery>
									
								 <cfloop query="Cost">
									<tr>
									<td align="center">#InvoiceCurrency#</td>
									<td>&nbsp;</td>
									<td>#numberformat(InvoiceAmount,"__,__.__")#</td>
									</tr>
								 </cfloop>
							
							</table>											
												
							<cfelse>							
							#LocationReference#
							</cfif>
							</td>
						</tr>
						
				</cfloop>
										
		</cfif>
								
	</cfoutput>
	
					
	<cfif URL.Topic eq "Trip">
	
		<cfset event = 0>
		
		<cfset cls = "TRM">
		
		<cfinclude template="ClaimEventPeriod.cfm"> 
		
		<cfif claim.claimAsIs eq "0">
			<cfset cls = "OTH">
			<cfinclude template="ClaimEventCost.cfm">									
		</cfif>
		
		<cfinclude template="ClaimEventAdditionalInfo.cfm"> 
				
		<cfif #refmenu# eq "0">
			<script language="JavaScript">
			  parent.left.history.go()
			</script>
		</cfif>
		
		<cfif pdf eq "0">
				
		<script language="JavaScript">
				
		     cnt = 1
			 cur = 0
			 while (cnt < 10) {
			     
				 se = parent.left.document.getElementById("menu"+cnt)
				 if (se) {
				  cur = cnt
				  se.className = "regular"
				 }
				 cnt++
			 }	 
			 
			 cur = cur-1			
			 se = parent.left.document.getElementById("menu"+cur)	
			 if (se) { se.className = "select"; }
	    </script>
		
		</cfif>
		
						 
	 </cfif>
					
	</table>	
		
	</tr>
	
	<tr><td height="1" colspan="4" class="noprint" valign="bottom" bgcolor="C0C0C0"></td></tr>
	
	</table>
			
	</td></tr>
			  
  <cf_waitEnd>
				   
  <cfif claim.actionStatus lte "1" and editclaim eq "1">
  
	 <!--- 
	 - refer to Tools/Process/Navigation/Navigation.cfm for a more complete explanation of the below custom tag
	 - the navigation bottom bar is only shown if the claim is in the edit mode editclaim = 1 and the claim
	 is not submitted (or has not yet been resubmitted).
	 --->
	 			
	<tr><td valign="bottom" height="30" class="noprint">
  
	  <cfif Object.recordcount eq "0" and Claim.ExportNo is "" or SESSION.isAdministrator eq "Yes">
		    <cfset reset = "1">			
		<cfelse>
	    	<cfset reset = "0">		
		</cfif>		
		
		
						
	    <cf_Navigation
		 Alias           = "AppsTravelClaim"
		 Object          = "Claim"
		 Group           = "TravelClaim" 
		 Section         = "#URL.Section#"
		 Id              = "#URL.ClaimId#"
		 ButtonClass     = "ButtonNav1"
		 Reload          = "1" <!--- enforced the left menu to be reloaded upon opening of this template --->
		 BackEnable      = "1"
		 HomeEnable      = "#reset#"
		 ResetEnable     = "#reset#"
		 ProcessEnable   = "#calc#" <!--- calculation button is only visible if this template is loaded to show claim summary --->
		 NextEnable      = "#enablenext#"
		 NextMode        = "#setNext#"  <!--- allows user to indeed click on the next option, 
		    otherwise next button will give a message enforcing him/her to finish the itinerary --->
		 SetNext         = "#setNext#">	<!--- determines if the section in ClaimSection is set as completed upon loading of this page
		 the value is determined based on the completion of the Itinerary records --->
		 		 
		  </td>
	  </tr>
			 
	</cfif>		
		  
  </table> 
