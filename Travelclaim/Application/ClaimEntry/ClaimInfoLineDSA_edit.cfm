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

<cfparam name="actionlogging" default="0">

<cfif actionlogging eq "0">
	
	<cf_ajaxRequest>
	
	<cfoutput>
	
	<script>
	
	function relink(row,no) {			
		
		url = "#SESSION.root#/travelclaim/application/claimentry/ClaimInfoLineDSA_editSave.cfm?ts="+new Date().getTime()+
		      "&claimrequestid=#claim.claimrequestid#"+
			  "&transactionno="+row+
			  "&claimrequestlineno="+no;
	
		AjaxRequest.get({
	        'url':url,
	        'onSuccess':function(req){ 
			
		document.getElementById("link"+row).innerHTML = req.responseText;},
						
	        'onError':function(req) { 
		document.getElementById("link"+row).innerHTML = req.responseText;}	
	         }
		 );					 
	}
	
	</script>
	
	</cfoutput>

</cfif>

<cfquery name="Detail" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   P.PersonNo, 
          LastName,
		  FirstName,
		  IndexNo,
		  Loc.LocationCode, 
		  Loc.Description as LocationDescription,
	   	  Rate,
		  Percentage, 
		  CalendarDate, 
		  Amount,
		  MatchingAction,
		  ClaimAutoMatching,
		  ClaimRequestId,
		  ClaimRequestLineNo,
		  TransactionNo
 FROM     ClaimLineDSA DSA, 
          stPerson P, 
		  Ref_PayrollLocation Loc
 WHERE    DSA.ClaimId      = '#Claim.ClaimId#'
 AND      P.PersonNo       = DSA.PersonNo
 AND      P.PersonNo       = '#PersonNo#'
 AND      Loc.LocationCode = DSA.LocationCode
 AND      Amount > 0					 
 ORDER BY P.PersonNo, CalendarDate 
</cfquery>

<cfquery name="Requested" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   D.*, 
	         R.Description as ClaimCategoryDescription, 
		     R.ClaimAmount,
		     R.DefaultIndicatorCode,
		     Loc.LocationCountry as Country, 
		     Loc.Description as LocationDescription,
			 L.PersonNo,
			 P.IndexNo, 
			 P.LastName, 
			 P.FirstName
	FROM     ClaimRequestLine L,
		 	 ClaimRequestDSA D,
	         Ref_ClaimCategory R,
		     Ref_PayrollLocation Loc,
		     stPerson P
	WHERE    L.ClaimCategory  = R.Code
	AND      L.PersonNo       = P.PersonNo
	AND      R.Code           = 'DSA'
	AND      L.ClaimRequestId = '#Claim.ClaimRequestId#'
	AND      L.ClaimRequestId = D.ClaimRequestId
	AND      L.ClaimRequestLineNo = D.ClaimRequestLineNo
	AND      Loc.LocationCode = D.ServiceLocation
	ORDER BY P.PersonNo 
</cfquery>
	
<cfset review = 0>
   
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">	

	<tr>
	   
		<td width="25"></td>
		<td width="50"><b>Code</b></td>
		<td width="100"><b>Location</b></td>
		<td width="100"><b>Date</b></td>
		<td width="70" align="right"><b>Rate</b></td>
		<td width="50" align="right"><b>Percent</b></td>		
		<td align="center">
		<table width="100%" cellspacing="0" cellpadding="0">
				<tr>
				<td colspan="2" align="center"><b>Associated TVRQ</b></td>		
				</tr>
		</table>		
		</td>
		<td width="100" align="right"><b>Amount</b></td>
		</tr>
		<tr><td colspan="8" bgcolor="C0C0C0"></td></tr>				

   <cfoutput query="Detail">
   
   <cfif Detail.ClaimAutomatching eq "0">   
	    <cfset review = "1">
   </cfif>
   
   <cfif URL.WParam neq "Accounts">
 		 	  
	  <tr height="18">
	  
	     <td>#currentrow#.</td>
		 <td>#LocationCode#</td>
		 <td>#LocationDescription#</td>
		 <td>#DateFormat(CalendarDate, CLIENT.DateFormatShow)#</td>
		 <td align="right">#NumberFormat(Rate,"__.__")#</td>
	     <td align="right">#Percentage#%</td>   	
         <td>
		 		
		 <!--- show field --->
		 			 
		 <cfif ClaimAutoMatching eq "1">
		 			 			 
				 <cfquery name="Match" 
		 			datasource="appsTravelClaim" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
		     			SELECT   *
						FROM     ClaimRequestLine 
					    WHERE    ClaimRequestId     = '#ClaimRequestId#'
						AND      ClaimRequestLineNo = '#ClaimRequestLineNo#'
				</cfquery>
				<table cellspacing="0" cellpadding="0">
				<tr><td width="30">			
			 	<img src="#SESSION.root#/Images/group3.gif" alt="Associated to" border="0" align="absmiddle">
				</td>
				<td>
					<table border="0" cellspacing="1" cellpadding="1">
					<tr><td>
				
					<cfquery name="DSA" 
			 			datasource="appsTravelClaim" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
			     			SELECT   *
							FROM     ClaimRequestDSA D, Ref_PayrollLocation R
							WHERE    D.ClaimRequestId     = '#ClaimRequestId#'
							AND      D.ClaimRequestLineNo = '#ClaimRequestLineNo#'
							AND      D.ServiceLocation = R.LocationCode 
					</cfquery>						
				 				 			
					<cfif DSA.recordcount eq "1">
					 
					  <font color="0080C0">#DSA.DSALineNo#.&nbsp; 
					  #DateFormat(DSA.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DSA.DateExpiration, CLIENT.DateFormatShow)# #DSA.ServiceLocation#-#DSA.Description#</b>
					  
					 <cfelse>
					 		
						 <div style="height:15;overflow-y: auto;">			 
						 <cfloop query = "DSA">
						
						    <font color="0080C0">#DSA.DSALineNo#.&nbsp; 
						    #DateFormat(DSA.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DSA.DateExpiration, CLIENT.DateFormatShow)# #DSA.ServiceLocation#-#DSA.Description# <br>
							
						 </cfloop>
						 
						  </div>
					 
					</cfif> 
					
					</td></tr>
					</table>
					
				</td></tr>
				</table>
					 
	 	<cfelse>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td width="50" align="center">
		
			<!--- edit field --->
	 													 
			 <img src="#SESSION.root#/Images/transfer.gif" 
				  alt="Transfered to" 
				  border="0" 
				  align="absmiddle">
				  
			</td><td width="50" bgcolor="ffffdf">	 
			
			 <cfif actionLogging eq "0">
				  
				 <input type="hidden" name="Line_#TransactionNo#" value="#TransactionNo#">
				 
				 <cfset Line = "#ClaimRequestLineNo#">
				 
				 <cfquery name="Lines" dbtype="query">
				     SELECT DISTINCT ClaimRequestLineNo
				     FROM   Requested
				 </cfquery>
				 
				 <select name="SelectLine_#TransactionNo#" onChange="relink('#transactionno#',this.value)">
					 <cfloop query = "Lines">
						 <option value="#ClaimRequestLineNo#" <cfif ClaimRequestLineNo eq line>selected</cfif>>
						   #ClaimRequestLineNo# 
						 </option>
					 </cfloop>
				 </select>
			 
			 </cfif> 
			 
			 </td>
			 <td height="22" align="left" bgcolor="ffffdf" id="link#transactionno#" style="border-bottom: 1 solid d1d1d1;">
			 
				 <div style="height:15;overflow-y: auto;">
			 
			     <cfif claimrequestid neq "">
			 			
					 <cfquery name="DSA" 
				 		datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
			     			SELECT   *
							FROM     ClaimRequestDSA D, Ref_PayrollLocation R
							WHERE    D.ClaimRequestId     = '#ClaimRequestId#'
							AND      D.ClaimRequestLineNo = '#ClaimRequestLineNo#'
							AND      D.ServiceLocation = R.LocationCode
					 </cfquery>
					
					
					 <cfloop query = "DSA">
						 
						<font color="0080C0">#DSA.DSALineNo#.&nbsp; 
						#DateFormat(DSA.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DSA.DateExpiration, CLIENT.DateFormatShow)# #DSA.ServiceLocation#-#DSA.Description#&nbsp;</br>
						 				 
					 </cfloop>
					
				 
				 <cfelse>
				 
				 <!--- the below should not happen in the first place --->
				 <font color="red">Problem, funding line could not be determined.</font>
				 
				 </cfif>
				 
				 </div>
			 
			 </td>
			 
			 </tr>
			 
			 </table>
						 
		 </cfif>
	 
	 </td>
	  <td align="right">#NumberFormat(Amount,"__.__")#&nbsp;</td>
	 </tr> 
			  
<cfelse>
  
  	<!--- accounts --->
  							   
	  <tr height="18">
	     <td width="20">#currentrow#.</td>
		 <td>#LocationCode#</td>
		 <td>#LocationDescription#</td>
		 <td>#DateFormat(CalendarDate, CLIENT.DateFormatShow)#</td>
		 <td align="right">#NumberFormat(Rate,"__.__")#</td>
	     <td align="right">#Percentage#%</td>         		 
         <td>				
		 			 			 
			 <cfquery name="Match" 
	 			datasource="appsTravelClaim" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
     			SELECT   *
				FROM     ClaimRequestLine 
			    WHERE    ClaimRequestId     = '#ClaimRequestId#'
				AND      ClaimRequestLineNo = '#ClaimRequestLineNo#'
			</cfquery>
		
		 	<img src="#SESSION.root#/Images/group3.gif" alt="Associated to" border="0" align="absmiddle">&nbsp;
			
			<cfquery name="DSA" 
	 			datasource="appsTravelClaim" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
     			SELECT   *
				FROM     ClaimRequestDSA
			    WHERE    ClaimRequestId     = '#ClaimRequestId#'
				AND      ClaimRequestLineNo = '#ClaimRequestLineNo#'
			</cfquery>
			 				 			
			<cfif DSA.recordcount eq "1">
			 
			  <font color="0080C0">Line #Match.ClaimRequestLineNo#.&nbsp; 
			  #DSA.ServiceLocation# &nbsp;#DateFormat(DSA.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DSA.DateExpiration, CLIENT.DateFormatShow)# </b>
			  
			 <cfelse>
			 				 
			 <cfloop query = "DSA">
			 
			  <font color="0080C0">Line #Match.ClaimRequestLineNo#-#DSA.DSALineNo#.&nbsp; 
			  #DSA.ServiceLocation# &nbsp;#DateFormat(DSA.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DSA.DateExpiration, CLIENT.DateFormatShow)# <br>
			 				 
			 </cfloop>
			 
			</cfif> 
						 
		 </td>
		 <td align="right">#NumberFormat(Amount,"__.__")#</td>
		 
   	  </tr> 
	    	  			  
</cfif>

</cfoutput>

<cfoutput>

<cfif review eq "1">
							
	 <tr><td colspan="7">
		   Confirm Claim - Request Line Association :
	   <input type="checkbox"
       name="Confirm_DSA"
       value="1"
	   <cfif Detail.MatchingAction eq "1">checked</cfif>
       onClick="ColdFusion.Ajax.submitForm('processaction','#SESSION.root#/TravelClaim/Application/ClaimEntry/ClaimInfoLineOTH_submit.cfm?val='+this.checked+'&claimid=#url.claimid#&claimcategory=DSA')">
	     </td>
	 </tr>
	 
</cfif>	 
		 
</cfoutput>		 

<cfoutput>
 
 <cfif review eq "1">
 
	<script>
	 document.getElementById("DSA_#PersonNo#Exp").click()
	</script>
	
</cfif>	

</cfoutput>
  
</table>