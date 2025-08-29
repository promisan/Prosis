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
<cfsilent>

	<proUsr>administrator</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes></proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	This template is the is the master template loaded for OTHER EXPENSES AND SFT EXPENSES screen. 
	</td></tr>
	</table>
	</proInfo>

	<proOwn>MKM</proOwn>
	<proDes>Multiple person types for same person</proDes>
	<proCom> MKM: Nov 20, 2008
I had fixed this once before but Hanno seems to have reverted the code.
Sometimes the ClaimRequestLine table will have different ClaimantTypes for the same person.
Changing the query to use ClaimRequest instead fixes this problem, but the Line table will be 
neccessary if we ever need to use the code for Multiple Travellers on one Claim and then
we'll need to really fix this code. </proCom>

</cfsilent>

<cf_wait1 text="Please wait" icon="circle" flush="no">

<html><head><title>Claim event entry</title></head>

<div class="screen">
<body leftmargin="5" topmargin="0" rightmargin="0" bottommargin="0">

<cfajaximport tags="cfWindow,cfdiv">

<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cfparam name="URL.Section" default="None"> <!--- default claim section status --->
<cfparam name="URL.Next"    default="1">    <!--- used for the navigation, default = 0--->
<cfparam name="URL.Leg"     default="0">    <!---  --->
<cfparam name="EditClaim"   default="1">    <!--- default claim edit status --->

<cfquery name="Parameter" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM Parameter 
</cfquery>

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM Claim R
    WHERE ClaimId = '#URL.ClaimId#'
</cfquery>

<cfquery name="Check" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
    FROM ClaimRequestItinerary D
    WHERE ClaimRequestId IN (SELECT ClaimRequestId 
	                         FROM Claim 
							 WHERE ClaimId = '#URL.ClaimId#')
</cfquery>

<cfif Check.recordcount eq "1">
			
		<cf_message message="Sorry, but the Requested Itinerary is not complete (city table)." Return="No">
		<cfabort>
			
</cfif>

<cfoutput>

<script language="JavaScript">
		
	function maximize(itm,icon){
							
		 se   = document.getElementById(itm)
		 icM  = document.getElementById(itm+"Min")
		 icE  = document.getElementById(itm+"Exp")
		 
		 if (se.className == "regular") {
		 se.className = "hide";
		 icM.className = "hide";
		 icE.className = "regular";
		 
		 } else {
		 se.className = "regular";
		 icM.className = "regular";
		 icE.className = "hide";		
		  window.scrollBy(0,100)	
		 }
	  }  
	 							
	 function hl(itm,fld){
			
		se = document.getElementById(itm)
				 			 	 		 	
		if (fld != false){
					
		 se.className = "highLight2";
		 				 
		 }else{
		 se.className = "regular";		
		  }
	  }
	  
	function delleg(ev,leg) {
	if (confirm("Are you sure you want to delete this record ?")) {
   	   window.location = "ClaimEventTripDelete.cfm?ClaimEventId="+ev+"&stop="+leg+"&section=#url.section#&ClaimId=#URL.ClaimId#&ID1=#URL.ID1#&Topic=#URL.Topic#"
	}
	 false	
	}	
	
	function selectcity(field,id) {
	   ColdFusion.Window.create('city', 'City Search', '',{x:100,y:100,minheight:510,height:510,minwidth:490,width:490,modal:true,center:true})
	   ColdFusion.navigate('../Inquiry/Lookup/City/CitySearch.cfm?field='+field+'&id='+id, 'city');
	}  
	
	function citysearch(field,id) {
	
		cit = document.getElementById("CitySelect")
		cde = document.getElementById("CityCodeSelect")
		cou = document.getElementById("CountrySelect")
			
	    ColdFusion.navigate('../Inquiry/Lookup/City/CitySearchResult.cfm?id='+id+'&field='+field+		
		             '&CitySelect='+cit.value+
		             '&CityCodeSelect='+cde.value+
					 '&CountrySelect='+cou.value,'cityresult')		 
			
	}	
		
	function cityselect(field,id,city) { 
	    ColdFusion.Window.hide('city')		  			    
	   	ColdFusion.navigate('ClaimEventEntryCity.cfm?claimtripid='+id+'&fld='+field+'&cityid='+city,field+"_fld")			
					
	}			 			   	
	
	function check() {
	
	    var i = 1;
		while (i < 3) {
		se = document.getElementById("arrcountry_"+i)
		
		if (se)	{ 
				if (se.value == "") {
				alert("You must define a stopover city location.")
				return false
				}
			}	
		
		i++;	
		}		

	}
		  
</script> 

</cfoutput>		

<cfparam name="URL.Topic" default="Trip">
<cfparam name="URL.Status" default="Default">

<cfquery name="TravelMode" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM Ref_ClaimEvent
	WHERE Operational = 1
</cfquery>

<cfif URL.ID1 eq "">
 <cfset URL.ID1 = "{00000000-0000-0000-0000-000000000000}">
</cfif>

<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="C0C0C0" rules="rows">

<cfform action="ClaimEventEntrySubmit.cfm?Next=#URL.Next#&Section=#URL.Section#&ClaimId=#URL.ClaimId#&ID1=#URL.ID1#&Topic=#URL.Topic#"
     method="POST" 
	 name="entry" 
	 onsubmit="return check()">

<cfif URL.Topic eq "Trip">
	<tr><td height="5"></td></tr>
	<tr><td height="30">
		  
		  <cfinclude template="ClaimPreparation.cfm">
		  
	 </td></tr>
	 <tr><td height="30" colspan="1" align="left"><font size="4" color="gray"><b>&nbsp;Edit Itinerary</font></td></tr>
	 <tr><td height="1" colspan="1" align="center" bgcolor="silver"></td></tr>
</cfif>

<cfif URL.ID1 neq "{00000000-0000-0000-0000-000000000000}">

	<!--- option to add legs has been disabled back in 2006, the below query and above <cfif></cfif> condition can be removed --->
   			
	<cfquery name="Event" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
	    FROM ClaimEvent C
	    WHERE ClaimEventId = '#URL.ID1#'
	</cfquery>
	
<cfelse>

	<tr><td valign="top">

	   <cfinclude template="ClaimEvent.cfm">
	   
	</td></tr>

	<tr><td height="4"></td></tr>

	<cfquery name="Event" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
	    FROM ClaimEvent C
	    WHERE ClaimEventId = '{00000000-0000-0000-0000-000000000000}'
	</cfquery>
	
</cfif>

<cfset show = "regular">

<cfif URL.Status eq "Default">

	<!--- determine if option to remove one or more legs should be shown to the claimant. --->
	
	<cfquery name="Last" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT max(LocationDate) as LocationDate
	    FROM   ClaimEventTrip T, ClaimEvent E
		WHERE  T.ClaimEventid = E.ClaimEventId
	    AND    E.ClaimId = '#URL.ClaimId#' 
	</cfquery>
	
	<cfquery name="Request" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT max(Date) as LastDate
	    FROM ClaimRequestItinerary D 
	    WHERE ClaimRequestId = '#Claim.ClaimRequestId#' 
	</cfquery>
	
	<cfif Request.LastDate lte Last.LocationDate>
		<cfset show = "hide">
	</cfif>
	
</cfif>

<cfquery name="Events" 
  datasource="appsTravelClaim" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ClaimEvent R
</cfquery>

<!--- the below section is not shown for claims uploaded from IMIS under status = 6 --->

<cfif claim.actionStatus lte "5">

<tr><td valign="top">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#C0C0C0">

	<tr><td colspan="4">
						
	<!--- general information --->
			
	<table width="100%" border="0" cellspacing="0" cellpadding="1" rules="rows" id="add" class="<cfoutput>#show#</cfoutput>">
					
	<tr><td height="1" colspan="2" bordercolor="silver"></td></tr>
		   							
	<cfoutput query="Event">
	
	<cfif URL.Topic eq "Trip">
<!--- MKM: Nov 20, 2008
I had fixed this once before but Hanno seems to have reverted the code.
Sometimes the ClaimRequestLine table will have different ClaimantTypes for the same person.
Changing the query to use ClaimRequest instead fixes this problem, but the Line table will be 
neccessary if we ever need to use the code for Multiple Travellers on one Claim and then
we'll need to really fix this code. --->					  
		<cfquery name="EventPerson" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT DISTINCT P.*, C.ClaimantType 
		 FROM   ClaimRequest C, 
		        stPerson P 
		  WHERE ClaimRequestId = '#Claim.ClaimRequestId#'
			AND C.PersonNo = P.PersonNo
		</cfquery>
				
		<cfif EventPerson.recordcount gte "2">
			<cfset cl = "regular">
		<cfelse>
		    <cfset cl = "hide">
		</cfif>		
				
		<tr class="#cl#">
		    <td width="100%" height="25" colspan="2">
			<table width="100%" border="0" frame="hsides" cellspacing="1" cellpadding="0" bordercolor="silver" bgcolor="white">
			<tr><td>
				<cfinclude template="ClaimEventEntryPerson.cfm">
			</td></tr>	
			</table>
			</td>
		</tr>		
				
		<tr>
		 <td colspan="2">
		 
			 <table width="100%" border="0" frame="hsides" cellspacing="0" cellpadding="1" bordercolor="silver" bgcolor="white">
								 		 						
			<!--- legs --->
					
				<cfset stopover = "0">		
				<tr>
			
				    <td colspan="1">
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="white" bordercolor="silver">
					<tr><td>
						<cfinclude template="ClaimEventEntryDeparture.cfm">
					 </td></tr>	
					</table>
					</td>
					
				</tr>
					  
		  <cfquery name="Check" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   distinct ClaimTripStop
			    FROM     ClaimEventTrip 
			    WHERE    ClaimEventId      = '#URL.ID1#'
   		  </cfquery>	
		  
		  <cfif URL.Leg eq "0">
		     <cfset legs = "#check.recordcount#">
		  <cfelse>	
		     <cfset legs = "#check.recordcount+1#"> 
		  </cfif>
		  
		  <!--- maximum of 4 stopovers --->
									
		  <cfloop index="stopover" list="1,2,3,4" delimiters=",">
												
				<cfquery name="TripArrival" 
					datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   TOP 1 *
				    FROM     ClaimEventTrip T,  System.dbo.Ref_Nation R 
				    WHERE    ClaimEventId      = '#URL.ID1#'
					AND      T.LocationCountry = R.Code
					AND      T.ClaimTripStop   = '#stopover#'
					<cfif Parameter.EnableGMTTime eq "0"> 
					ORDER BY LocationDate 
					<cfelse>
					ORDER BY LocationDateGMT
					</cfif>
				</cfquery>	
						
				<cfset bd = 0>			 
				<cfif #TripArrival.recordcount# gt "0">
				    <cfset show = "3"> <!--- show + add button --->
					<cfset bd = "1">
				<cfelseif URL.leg eq "1">
				    <cfset show = "3">
					<cfset bd = "1">
					<cfset url.leg = "0">
				<cfelseif stopover eq "#legs#">						
				    <cfset show = "1"> <!--- add button only --->
				<cfelse>
				    <cfset show = "0">
				</cfif>
				
				<cfset leg = "0">
				
				<cfif show neq "0">
																			
				<tr>
				
				    <td id="stopover_#stopover#">
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="white">
					<tr>
				      <td>
					    <cfset calendar = "1"> 
						<cfinclude template="ClaimEventEntryArrival.cfm">
					  </td>
					</tr>  	
					</table>	
					
					</td>
				</tr>
				
				</cfif>
																		
			</cfloop>
					
			<cfset stopover = "0">		
			
			<cfquery name="TripArrival" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT TOP 1 *
			    FROM  ClaimEventTrip T,  
				      System.dbo.Ref_Nation R 
			    WHERE ClaimEventId      = '#URL.ID1#'
				AND   T.LocationCountry *= R.Code
				AND   T.ClaimTripMode   = 'Arrival'
				AND   T.ClaimTripStop   = '0'
			 </cfquery>	
			 			
			<tr>	
				
				<td colspan="2">
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="white" bordercolor="silver">
				<tr>
				   <td>
					   <cfset URL.id = "#Claim.ClaimRequestId#">
					   <cfinclude template="ClaimEventEntryArrival.cfm">
					</td>
				</tr>	
				</table>
				</td>
							
			</tr>	
			
			 </table>
			 
		 </td></tr>
						
		<cfelse>
		
			<tr><td height="6"></td></tr>
			
			<tr><td height="1" colspan="2">
		  
			  <cfinclude template="ClaimPreparation.cfm">
		  
			   </td>
			</tr>		 
			 									
			<tr>
				
				 <td width="100%" colspan="2" valign="top">
				 <table width="100%" border="0" frame="hsides" cellspacing="1" cellpadding="0" bordercolor="silver" bgcolor="white">
					<tr><td valign="top">					
					 	<cfinclude template="ClaimEventEntryIndicatorEntry.cfm">					
					</td></tr>	
				 </table>
				 </td>
				
			</tr>
				
		</cfif>
	
	</cfoutput>
	
	</table>
	
	</td></tr>
			
</cfif>
					
</table>

</tr>

<cfif claim.actionStatus lte "1" and editclaim eq "1">
	
	<cfif URL.Topic eq "Trip" and URL.Status eq "Edit">
	
		<!--- -------------------------------Hanno------------------------------------ --->
		<!--- 17/8/2008 determine if this conditional template portion is used for SFT --->
		<!--- ------------------------------------------------------------------------ --->
	
		<tr>
		 
		<td colspan="2" height="50" align="center">
										
		<cf_Navigation
			 Alias         = "AppsTravelClaim"
			 Object        = "Claim"
			 Group         = "TravelClaim" 
			 Section       = "#URL.Section#"
			 Id            = "#URL.ClaimId#"
			 ButtonClass   = "ButtonNav1"
			 BackEnable    = "1"
			 BackDefault   = "1"
			 HomeEnable    = "0"
			 ResetEnable   = "0"
			 ProcessEnable = "0"
			 NextEnable    = "1"
			 NextName      = "Done"
			 NextSubmit    = "1" <!--- handles the next button as a form submit ClaimEventEntrySubmit.cfm see form above --->
			 NextMode      = "#URL.Next#"
			 SetNext       = "#URL.Next#"> <!--- automatically sets the section as completed upon loading of this page as we do not enforce entry of costs --->
					 	
		</td>
		
		</tr>	
				
	<cfelseif URL.Status eq "Edit">	
	
	<tr><td height="1" colspan="2" valign="bottom" bgcolor="C0C0C0"></td></tr>
	
	<tr>
		 
		<td colspan="2" height="35" valign="bottom" align="center">
				
		<cfif Object.recordcount eq "0" and Claim.ExportNo is "">
		    <cfset reset = "1">			
		<cfelse>
	    	<cfset reset = "0">		
		</cfif>
		
		<!--- ------------------------------------------------------------------------ --->
		<!--- ----------- other costs ------------------------------------------------ --->
		<!--- ------------------------------------------------------------------------ --->
						 		
		<cf_Navigation
			 Alias         = "AppsTravelClaim"
			 Object        = "Claim"
			 Group         = "TravelClaim" 
			 Section       = "#URL.Section#"
			 Id            = "#URL.ClaimId#"
			 ButtonClass   = "ButtonNav1"
			 BackEnable    = "1"
			 HomeEnable    = "#reset#"
			 ResetEnable   = "#reset#"
			 ProcessEnable = "0"
			 NextEnable    = "1"
			 NextSubmit    = "0"
			 NextMode      = "#URL.Next#" <!--- determines if you can indeed click this button --->
			 SetNext       = "0">		 
		
		</td>
		
		</tr>	
		
	</cfif>	 

</CFIF>

</cfform>

</table>

<cf_waitEnd>

</body>

