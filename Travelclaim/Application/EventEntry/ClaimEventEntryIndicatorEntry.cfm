
<!--- PENDING, select only indicators that relate to a cost that has been requested in the claim request,
 if not DSA, remove DSA related questions --->
<!---- ----------------------------Modification Details-------------------------------------------------------------------------------
				Date: 		20/10/2008
				By: 		Huda Seid
				Detail:     Added the  help icon tag for id-"OTH" and portion of the help content. And the below text
				If you are unsure of the miscellaneous expenses policy of the UN Secretariat, please click here

------------------------------------------------------------------------------------------------------------------->
<cfquery name="EventIndicator" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT DISTINCT R.*, IC.Description as CategoryDescription, ClaimSectionText
  FROM   Ref_ClaimEventIndicator I, 
         Ref_Indicator R,
		 Ref_IndicatorCategory IC
  WHERE  I.IndicatorCode = R.Code
  <!--- limit access for air, land action --->
  AND    I.EventCode IN (SELECT EventCode 
                         FROM ClaimEventTrip 
						 WHERE ClaimEventId IN (SELECT ClaimEventId 
						                        FROM ClaimEvent 
												WHERE ClaimId = '#URL.ClaimId#'))
												
  <!--- limit access to cost code based on travel request raised --->						 
  AND    (R.Code IN (SELECT I.IndicatorCode 
                             FROM  Ref_ClaimCategoryIndicator I, 
							       ClaimRequestLine R
							 WHERE I.ClaimCategory = R.ClaimCategory
							 AND   R.ClaimRequestId = '#Claim.ClaimRequestid#'))									 
  AND    R.Category = '#URL.Topic#' 
  AND    R.Category = IC.Code  
  <cfif editclaim eq "0">
  AND    I.IndicatorCode IN (SELECT IndicatorCode 
                             FROM ClaimEventIndicator
							 WHERE ClaimEventid IN (SELECT ClaimEventId FROM ClaimEvent WHERE ClaimId = '#URL.ClaimId#'))
  </cfif>
  
  UNION   
   
  
  SELECT DISTINCT R.*, IC.Description as CategoryDescription, ClaimSectionText
  FROM   Ref_ClaimEventIndicator I, 
         Ref_Indicator R,
		 Ref_IndicatorCategory IC
  WHERE  I.IndicatorCode = R.Code
 
  <!--- limit hardcoded access to cost code LTR based on travel request raised --->						 
  AND    (R.Code IN (SELECT I.IndicatorCode 
                             FROM  Ref_ClaimCategoryIndicator I, 
							       ClaimRequestLine R
							 WHERE I.ClaimCategory = R.ClaimCategory
							 AND   R.ClaimRequestId = '#Claim.ClaimRequestid#'
							 AND   R.ClaimCategory = 'LTR'))									 
  AND    R.Category = '#URL.Topic#' 
  AND    R.Category = IC.Code  
   <cfif editclaim eq "0">
  AND    I.IndicatorCode IN (SELECT IndicatorCode 
                             FROM ClaimEventIndicator
							 WHERE ClaimEventid IN (SELECT ClaimEventId FROM ClaimEvent WHERE ClaimId = '#URL.ClaimId#'))
  </cfif>  
  ORDER BY EnableShow DESC, R.Category, R.ListingOrder 

  
</cfquery>

<cfquery name="Check" 
   datasource="appsTravelClaim" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM   ClaimEventIndicator C, 
	         ClaimEventIndicatorCost Cost
	  WHERE  C.ClaimEventId = '#URL.ID1#'
	  	AND  C.ClaimEventid =  Cost.ClaimEventId
		AND  C.IndicatorCode = Cost.IndicatorCode  
</cfquery>
	 
<cfif #Check.recordcount# gt "0">
  <cfset ta = "regular">
  <cfset tb = "hide">
<cfelse>
  <cfset ta = "hide">  
  <cfset tb = "regular">
</cfif>		

<cfquery name="Base" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT TOP 1 Currency
  FROM   ClaimRequestLine
  WHERE ClaimRequestId = '#Claim.ClaimRequestId#'
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="1">

	<tr>
	<td colspan="4" valign="top">
	
	<table width="100%">
			
	<cfquery name="Section" 
			datasource="AppsTravelClaim">
			SELECT   *
			FROM     #CLIENT.LanPrefix#Ref_ClaimSection 
			WHERE    Code = '#Section#' 
		</cfquery>
	
	<tr>
		<td height="28">
		<table cellspacing="0" cellpadding="0"><tr>
		<td width="25"><cfoutput><img src="#SESSION.root#/Images/join.gif" alt="" border="0"></cfoutput></td>					
		<td>
		<font face="Verdana" size="3" color="gray">&nbsp;<b><cfoutput>#Section.Description#</cfoutput></td>
		<td>&nbsp;</td>
		<td align="left">
		
		<!--- 		
				<cf_helpfile code     = "TravelClaim" 
							 id       = "#Section.Code#" 
							 class    = "General"
							 name     = "#Section.Description#"
							 display  = "Icon"
							 displayText = "#Section.Description#"
							 color    = "black">
							 
		--->
							 
		</td>
		</tr>
		</table>
		
	</tr>
	
	</table>
	</tr>	
	
	<cfoutput query="EventIndicator" group="Category">
	
	<cfif claim.actionstatus lte "1"  and editclaim eq "1">
						 
	<tr>
	    <td align="center" width="40">
												
		<img src="#SESSION.root#/Images/finger.gif" 
				alt="Show"  
				id="#Category#Exp" border="0" 
				align="middle">		
				
		</td>
	    <td colspan="3" width="94%">		
				  <table width="100%" height="16" border="0" cellspacing="1" cellpadding="1" bordercolor="E1E1E1" rules="rows">
					  <tr>
					 					  
					  <td colspan="2">#claimSectionText#&nbsp;</td>	
					  
				<!---HS: 17/10/2008 Add help tag to reference the section under other Expenses.--->
				 	
							
					</td>
					</tr>
					<tr>
					<td>If you are unsure of the miscellaneous expenses policy of the UN Secretariat, please click here</td>
					<td align="left" width="300">
					<cf_helpfile 
					        code    = "TravelClaim" 
							class   = "Indicator"
							id      = "OTH"
							display = "icon">
					</td> </tr>
				  </table>						  						
		</td>		
	</tr>	
	
	</cfif>
	
	<tr><td height="6"></td></tr>
	
	<tr><td colspan="4">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" id="#category#" class="regular">		
				 
	<cfoutput>
	
	<cfquery name="Verify" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM ClaimEventIndicator
		  WHERE ClaimEventId = '#URL.ID1#'
			AND IndicatorCode  = '#Code#' 
			AND IndicatorValue = '1'
		</cfquery>
			
		<cfif Verify.recordcount gte "1">
			 <cfset cl = "highlight2">
		<cfelse>
			 <cfset cl = "regular">
		</cfif>	
	 
		<cfif CurrentRow eq "1">
		
		  <tr>
		    <td width="100%" colspan="6" align="center">
		    <table width="740" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" rules="rows">
			
			<cfif claim.actionstatus lte "1" and editclaim eq "1">
			<TR>
			   <td width="200">Description <font color="FF0000">(required)</font></td>
			   <td width="115">Date <font color="FF0000">(required)</font> <!--- <font size="1">dd/mm/yy</font> ---></td>
			   <td width="120">Additional Info</td>
			   <td width="85">
			   <table border="0" cellspacing="0" cellpadding="0">
			   <tr><td>Currency</td>
				   <td></td>
			   </tr>
			   </table>			   
			   </td>
			   <td width="100" align="right">Amount <font color="FF0000">(required)</font></td>
			   <td width="120"></td>
		    </TR>
			<cfelse>
			<TR>
			   <td width="200">Description</td>
			   <td width="115">Date</td>
			   <td width="120">Additional Info</td>
			   <td width="85">Claim Currency</td>
			   <td width="100" align="right">Amount</td>
			   <td width="120"></td>
		    </TR>
			</cfif>
			
			<tr><td colspan="7" bgcolor="silver"></td></tr>
			
			</table>
			</td>
		  </tr>	
		  
		 </cfif> 
		 
		<cfif EnableShow eq "0" > 
	 	
		<tr class="#cl#" id="#Code#">
		    
			<td colspan="6" height="28">
			
			<table width="100%">
			<tr>
			
				<td>
				
				<table cellspacing="0" cellpadding="0"><tr><td>
				&nbsp;
	
				<img src="#SESSION.root#/Images/childnode.gif" 
					alt="Enter costs"  
					align="absmiddle" 
					border="0">
											
				<font face="Verdana">
				<b>#DescriptionQuestion#</b>
				</font>							
				</td>
				<td>&nbsp;</td>				
				<td width="30" colspan="1">
				
				 <cf_helpfile 
					        code    = "TravelClaim" 
							class   = "Indicator"
							id      = "#Code#"
							name    = "#Description#"
							display = "icon">
							 
				</td>
				
				</table>
				</td>
			
			</tr>
			</table>
			
			</td>
			
		</tr>
		
	<cfelse>
	
	  <input type="hidden" name="IndicatorValue_#Code#" value="1">
				 
	</cfif>
		
	<cfif Verify.recordcount gte "1" or EnableShow eq "1">
	   <cfset cls = "regular">
	<cfelse>
	   <cfset cls = "regular">
	   <!--- 
	   <cfset cls = "hide">
	   --->
	</cfif>
		
	<tr id="b#Code#" class="#cls#">
	<td colspan="4" bgcolor="white">	
	<cfinclude template="ClaimEventEntryIndicatorEntryCost.cfm">	
	</td>
	</tr>		
	<cfif currentRow neq "#EventIndicator.recordcount#">
		<tr><td colspan="4"></td></tr>
	</cfif>
	
	</cfoutput>	 
	
	</table></td></tr>
	
	</cfoutput>	
			
</table>

	
			