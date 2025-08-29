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
<proOwn>Dev van Pelt</proOwn>
<proDes></proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template presents information on the claims for the claimant. The subsection of the home page are specifically defined as it would be possible to define a list of headings and loop through them to show the information under the heading. The main reason was to allow developers to easily adjust the presentation of this screen to the user with different subheadings as the number and content of the subheadings changed frequently during the development process. Current we have 4 sub sections

- Pending claims
- Submitted claims
- Settled Claims
- Other claims

</td></tr>
</table>
</proInfo>

</cfsilent>

<cfparam name="URL.PersonNo" default="#client.personNo#">

<cfoutput>
	
<script language="JavaScript">
		
	function maximize(itm){
	 
	 se   = document.getElementsByName(itm)
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 count = 0
	 

		 
	 if (icM.className == "regular") {
	 icM.className = "hide";
	 icE.className = "regular";

	 
	 while (se[count]) {
	   se[count].className = "hide"
	
	   count++ }
	 
	 } else {
	 	 
	 while (se[count]) {
	 se[count].className = "regular"
	 count++ }
	 icM.className = "regular";
	 icE.className = "hide";			
	 }
  } 

		  
</script> 

<cfset header1 = "002350">
<cfset header1Size = "2">

<!--- clean double claims as they sometimes appeared --->		
<cfinclude template="ClaimViewListingClear.cfm">

<cfset FileNo = round(Rand()*100)>

<CF_DropTable dbName="AppsQuery" tblName="clm#SESSION.acc#ClaimTrip#fileNo#">	

<cfquery name="Subset" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   R.ClaimRequestId, 
	         MIN(T.DateDeparture) AS DateDeparture, 
			 MAX(T.DateReturn) AS DateReturn
	INTO     userQuery.dbo.clm#SESSION.acc#ClaimTrip#Fileno#
	FROM     ClaimRequestItinerary T, 
	         ClaimRequest R,
			 ClaimRequestLine L
	WHERE    R.PersonNo           = '#URL.PersonNo#'
	AND      L.ClaimRequestId     = R.ClaimRequestId
	AND      T.ClaimRequestId     = L.ClaimRequestId 
	AND      T.ClaimRequestLineNo = L.ClaimRequestLineNo
	AND      T.ClaimRequestId = R.ClaimRequestId
	GROUP BY R.ClaimRequestId 
</cfquery>


<table width="100%" align="center" height="94%" border="0" cellspacing="0" cellpadding="0">

<tr>

<!--- Depreciated function we once used to show a summary of the listed claims in the left panel of the home page, was disabled.

The code can be removed (12/8/2008.

<td width="160" height="150" valign="top" background="<cfoutput>#SESSION.root#</cfoutput>/images/HeaderMenu1b.jpg"> 

<table width="100%" cellspacing="2" cellpadding="2">
<tr>

<td valign="top">

<cfloop index="itm" list="Pending,Submitted" delimiters=",">

<table width="100%"
       border="1"	
	   bordercolor="6688aa"  
       cellspacing="3"
       cellpadding="3"
	   bgcolor="ffffff"	  
	   align="center">
  	<tr>
	<td height="31">
	 #itm#:
	 <br>
	 
	 <cfset amount = "0">
	 	 
	 <cfif itm eq "Submitted">
	  
		 <cfquery name="Sum" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    SUM(ClaimLine.AmountClaimBase) AS Total, 
		          count(distinct DocumentNo) as Number
		FROM      Claim INNER JOIN
	              ClaimLine ON Claim.ClaimId = ClaimLine.ClaimId
		WHERE     Claim.PersonNo = '#URL.PersonNo#' 
		AND       ActionStatus > '1' and ActionStatus != '6'
		</cfquery> 
		
		<cfif Sum.Total eq "">
			 <cfset amount = "0">
		<cfelse>
			 <cfset amount = "#Sum.Total#"> 
		</cfif>
		
	<cfelseif itm eq "Pending">
	
	 <cfquery name="Sum" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    SUM(ClaimLine.AmountClaimBase) AS Total, 
		          count(distinct DocumentNo) as Number
		FROM      Claim INNER JOIN
	              ClaimLine ON Claim.ClaimId = ClaimLine.ClaimId
		WHERE     Claim.PersonNo = '#URL.PersonNo#' 
		AND       ActionStatus <= '1' 
		</cfquery> 
		
		<cfif #Sum.Total# eq "">
			 <cfset amount = "0">
		<cfelse>
			 <cfset amount = "#Sum.Total#"> 
		</cfif>	
		
	<cfelseif #itm# eq "Not claimed">	
	
	 <cfquery name="Sum" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  SUM(RequestAmount) AS Total, 
		        count(distinct DocumentNo) as Number
		FROM      ClaimRequest INNER JOIN
	              ClaimRequestLine ON ClaimRequest.ClaimRequestId = ClaimRequestLine.ClaimRequestId
		WHERE   ClaimRequest.PersonNo = <cfqueryparam value="#URL.PersonNo#" 
		                    cfsqltype="CF_SQL_VARCHAR" 
							maxlength="10">  
		AND    (
		    ClaimRequest.ClaimRequestId NOT IN (SELECT ClaimRequestid 
		                           FROM Claim)
		    OR  ClaimRequest.ClaimRequestId NOT IN (SELECT ClaimRequestid 
		                           FROM ClaimLine)
			   ) 
		
		</cfquery> 
		
		<cfif Sum.Total eq "">
			 <cfset amount = "0">
		<cfelse>
			 <cfset amount = Sum.Total> 
		</cfif>
		
	 </cfif>
	 
		&nbsp;#Sum.number#:&nbsp;&nbsp;<b>USD #numberFormat("#amount#","__,__.__")# </b>	 
	
	 </td>
  </tr>	 
  
</table>

<table>
<tr><td height="2"></td></tr>
</table>


</cfloop>

</td>
  
</table>

--->

<td valign="top">
		
	<table width="99%" align="center" border="0" cellspacing="1" cellpadding="1">
		
	</tr>
	<tr><td height="3"></td></tr>
	<tr><td>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
		<font face="Ms Trebuchet" size="#header1Size#" color="#header1#"><b>Pending claims
		</td>
		<td align="right">							
				<cf_helpfile code = "TravelClaim" 
				    id      = "FAQ" 
					color   = "002350"
					display = "Both">	
		</td>
	</tr></table>			
	</td></tr>
	<tr><td height="2"></td></tr>
	<tr><td><font face="Verdana" size="1">&nbsp;&nbsp;&nbsp;
	Click the Travel Request Number to start your travel claim </td></tr>
	<tr><td height="3"></td></tr>
	
	<cfset URL.show   = "1">
	<cfset URL.Text   = "Pending claims">
	<cfset URL.ID1    = "No claimed">
	<cfset URL.ID     = "REQ">
	<cfset URL.FileNo = "1">
	
	<tr><td height="2"></td></tr>
	<tr>
	<td>
	
	    <table width="98%" align="right">
			<tr><td><cfinclude template="ClaimViewListing.cfm"></td></tr>
		</table>
	
	</td>
	</tr>	
	<tr><td height="4"></td></tr>
	<tr><td height="1" bgcolor="e0e0e0"></td></tr>	
	<tr><td height="4"></td></tr>
			
	<cfset URL.show = "0">
	<cfset URL.Text = "Submitted Claims">
	<cfset URL.ID1 = "2">
	<cfset URL.ID = "STA">
	<cfset URL.FileNo = "2">
	
	<cfif URL.Show eq "1">
		<cfset cl = "regular">
		<cfset clt = "hide">
	<cfelse>
		<cfset cl = "hide">
		<cfset clt = "regular">
	</cfif>
	
	<tr><td>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	 <tr>
	 <td align="center" width="30">
	 
	 <img src="#SESSION.root#/Images/expand5.gif" alt="Expand" 
	            onMouseOver="document.d#URL.id1#Exp.src='#SESSION.root#/Images/expand-over.gif'" 
			    onMouseOut="document.d#URL.id1#Exp.src='#SESSION.root#/Images/expand5.gif'"
				name="d#URL.id1#Exp" border="0" class="#clt#" 
				id="d#URL.id1#Exp"
				align="absmiddle" style="cursor: hand;"
				onClick="maximize('d#URL.ID1#')">
				
				<img src="#SESSION.root#/Images/collapse5.gif" 
				onMouseOver="document.d#URL.id1#Min.src='#SESSION.root#/Images/collapse-over.gif'" 
			    onMouseOut="document.d#URL.id1#Min.src='#SESSION.root#/Images/collapse5.gif'"
				name="d#URL.id1#Min" alt="Collapse" border="0" 
				id="d#URL.id1#Min"
				align="absmiddle" class="#cl#" style="cursor: hand;"
				onClick="maximize('d#URL.ID1#')">
				

	 	  </td>			
	  <td style="cursor: hand;" onClick="maximize('d#URL.ID1#')" >
	    <font face="Ms Trebuchet" size="#header1Size#" color="#header1#"><b>Submitted claims
	 </td>
	  </tr>
	</table>
	</td>	
	</tr>
	<tr id="d#URL.ID1#" name="d#URL.ID1#" class="#cl#"><td><font face="Verdana" size="1">&nbsp;&nbsp;&nbsp;
	Click the Travel Request Number to view the status of a claim</td></tr>
	<tr id="d#URL.ID1#" name="d#URL.ID1#" class="#cl#"><td height="3"></td></tr>
	
	<tr id="d#URL.ID1#" name="d#URL.ID1#" class="#cl#">
	<td>
	    <table width="98%" align="right">
		<tr><td>
		<cfinclude template="ClaimViewListing.cfm"> 
		</td></tr>
		</table>
	</td>
	</tr>	
	<tr><td height="4"></td></tr>
	<tr><td height="1" bgcolor="e0e0e0"></td></tr>	
	<tr><td height="4"></td></tr>
	
	<cfset URL.show   = "0">
	<cfset URL.Text   = "Settled Claims">
	<cfset URL.ID1    = "5">
	<cfset URL.ID     = "STA">
	<cfset URL.FileNo = "3">
	
	<cfif URL.Show eq "1">
		<cfset cl  = "regular">
		<cfset clt = "hide">
	<cfelse>
		<cfset cl  = "hide">
		<cfset clt = "regular">
	</cfif>
	
	<tr><td>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	 <tr>
	 <td align="center" width="30">
	
	 <img src="#SESSION.root#/Images/expand5.gif" alt="Expand" 
	            onMouseOver="document.d#URL.id1#Exp.src='#SESSION.root#/Images/expand-over.gif'" 
			    onMouseOut="document.d#URL.id1#Exp.src='#SESSION.root#/Images/expand5.gif'"
				name="d#URL.id1#Exp" border="0" class="#clt#" 
				id="d#URL.id1#Exp"
				align="absmiddle" style="cursor: hand;"
				onClick="maximize('d#URL.ID1#')">
				
				<img src="#SESSION.root#/Images/collapse5.gif" 
				onMouseOver="document.d#URL.id1#Min.src='#SESSION.root#/Images/collapse-over.gif'" 
			    onMouseOut="document.d#URL.id1#Min.src='#SESSION.root#/Images/collapse5.gif'"
				name="d#URL.id1#Min" alt="Collapse" border="0" 
				id="d#URL.id1#Min"
				align="absmiddle" class="#cl#" style="cursor: hand;"
				onClick="maximize('d#URL.ID1#')">
				
	 </td>			
	 <td style="cursor: hand;" onClick="maximize('d#URL.ID1#')">
	 <font face="Ms Trebuchet" size="#header1Size#" color="#header1#"><b>Settled Claims
	 </td>	
	  </tr>
	</table>
	</td></tr>
	<tr id="d#URL.ID1#" name="d#URL.ID1#" class="#cl#"><td><font face="Verdana" size="1">&nbsp;&nbsp;&nbsp;Click the Travel Request Number to view a settled claim</td></tr>
	<tr id="d#URL.ID1#" name="d#URL.ID1#" class="#cl#"><td height="3"></td></tr>
	
	<tr id="d#URL.ID1#" name="d#URL.ID1#" class="#cl#">
	<td>
	    <table width="98%" align="right">
		<tr><td>
		<cfinclude template="ClaimViewListing.cfm"> 
		</td></tr>
		</table>
	</td>
	</tr>	
	<tr><td height="4"></td></tr>
	<tr><td height="1" bgcolor="e0e0e0"></td></tr>	
	<tr><td height="4"></td></tr>	
	<tr><td>
	
	<cfset URL.show = "0">
	<cfset URL.Text = "Other claims">
	<cfset URL.ID1 = "6">
	<cfset URL.ID = "STA">
	<cfset URL.FileNo = "4">
	
	<cfif URL.Show eq "1">
		<cfset cl  = "regular">
		<cfset clt = "hide">
	<cfelse>
		<cfset cl  = "hide">
		<cfset clt = "regular">
	</cfif>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	 <tr>	
	 <td align="center" width="30">
	 
	 <img src="#SESSION.root#/Images/expand5.gif" alt="Expand" 
	            onMouseOver="document.d#URL.id1#Exp.src='#SESSION.root#/Images/expand-over.gif'" 
			    onMouseOut="document.d#URL.id1#Exp.src='#SESSION.root#/Images/expand5.gif'"
				name="d#URL.id1#Exp" border="0" class="#clt#" 
				id="d#URL.id1#Exp"
				align="absmiddle" style="cursor: hand;"
				onClick="maximize('d#URL.ID1#')">
				
				<img src="#SESSION.root#/Images/collapse5.gif" 
				onMouseOver="document.d#URL.id1#Min.src='#SESSION.root#/Images/collapse-over.gif'" 
			    onMouseOut="document.d#URL.id1#Min.src='#SESSION.root#/Images/collapse5.gif'"
				name="d#URL.id1#Min" alt="Collapse" border="0" 
				id="d#URL.id1#Min"
				align="absmiddle" class="#cl#" style="cursor: hand;"
				onClick="maximize('d#URL.ID1#')">
				
	  </td>			
	  <td style="cursor: hand;" onClick="maximize('d#URL.ID1#')">
	   <font face="Ms Trebuchet" size="#header1Size#" color="#header1#"><b>Other Claims
	 </td>
	  </tr>
	</table>
	
	</td></tr>
	<tr id="d#URL.ID1#" name="d#URL.ID1#" class="#cl#"><td><font face="Verdana" size="1">&nbsp;&nbsp;&nbsp;Click the Travel Request Number to view claims raised outside the Travel Claim Portal</td></tr>
	<tr id="d#URL.ID1#" name="d#URL.ID1#" class="#cl#"><td height="3"></td></tr>
	
	<tr id="d#URL.ID1#" name="d#URL.ID1#" class="#cl#">
	<td>
	    <table width="98%" align="right" >
		<tr><td>
		<cfinclude template="ClaimViewListing.cfm"> 
		</td></tr>
		</table>
	</td>
	</tr>	
	</table>	

</td></tr>
</table>

<CF_DropTable dbName="AppsQuery" tblName="clm#SESSION.acc#ClaimTrip">	

</cfoutput>	 
