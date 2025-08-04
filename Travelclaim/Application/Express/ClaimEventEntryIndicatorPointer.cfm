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

<!--- PENDING, select only indicators that relate to a cost that has been requested, if not DSA, 
remove DSA related questions --->

<cfparam name="Attributes.ClaimSection"  default="">
<cfparam name="Attributes.Class"         default="regular">
<cfparam name="Attributes.Category"      default="">
<cfparam name="Attributes.TripId"        default="">
<cfparam name="Attributes.width"         default="200">
<cfparam name="Attributes.line"          default="0">
<cfparam name="Attributes.fld"           default="">
<cfparam name="Attributes.status"        default="1">
<cfparam name="Attributes.editclaim"     default="1">
<cfparam name="Attributes.value"         default="">

<cfset category  = "#Attributes.category#">
<cfset fld       = "#Attributes.fld#">
<cfset tripid    = "#Attributes.tripid#">

<cfif tripid eq "">
 <cfset tripId = "{00000000-0000-0000-0000-000000000000}">
</cfif>

<cfquery name="EventIndicator" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT DISTINCT *
  FROM   Ref_Indicator R 
  WHERE  Operational = 1
  <cfif attributes.ClaimSection neq "">   
  AND    R.Category IN (SELECT Code FROM Ref_IndicatorCategory WHERE ClaimSection = '#attributes.ClaimSection#')  
  <cfelse>
  AND    R.Category IN (#preserveSingleQuotes(Category)#)   		
  </cfif>  
  ORDER BY R.Category, R.ListingOrder 
</cfquery>

<table width="100%" class="<cfoutput>#attributes.class#</cfoutput>" align="center" border="0" cellspacing="0" cellpadding="0">
		
	<cfoutput query="EventIndicator">
		
	<cfquery name="Verify" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM  ClaimEventTripIndicator
		 WHERE ClaimTripId = '#tripid#' 
		 AND   IndicatorCode  = '#Code#'  
	</cfquery>
		
	<cfif category eq "Additional" or attributes.claimsection eq "subsistence">	
			
		<cfif Verify.recordcount eq "0">
		
			<cfquery name="Verify" 
				 datasource="appsTravelClaim" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT TOP 1 *
				 FROM  ClaimEventTripIndicator
				 WHERE ClaimEventId IN (SELECT ClaimEventId 
				                       FROM ClaimEvent 
									   WHERE ClaimId = '#URL.ClaimId#') 
				 AND   IndicatorCode  = '#Code#'  
			</cfquery>
					
		</cfif>
		
		<cfset caller.IndicatorReturn = Verify.IndicatorValue>
	
	</cfif>
				
	<cfif Verify.recordcount gte "1">
		 <cfset cl = "regular">
	<cfelse>
		 <cfset cl = "regular">
	</cfif>
	  
	<cfif attributes.line eq "1" and attributes.status lt "2">
		<tr><td height="1" colspan="3" bgcolor="e3e3e3"></td></tr>
	</cfif>
		 	
	<tr class="#cl#" id="#fld##Code#" bgcolor="#listingbackground#">
	    										
		<td align="left" width="#Attributes.width#">
				
		<cfswitch expression="#LineInterface#">
		
			<cfcase value="CheckBox">
						
			 <table width="100%" cellspacing="1" cellpadding="1">
			
			 <tr>
			      <td width="30">  
												
        		<cfif attributes.status lt "2" and attributes.editclaim eq "1">				
				
				   <input type="checkbox" 
				   name="#fld##Code#" 
				   id="#fld#"
				   value="1" 
				   <cfif attributes.status gte "2">disabled</cfif>
				   onClick="hl('#fld##Code#',this.checked)"
				   <cfif Verify.indicatorValue eq "1" or (attributes.value eq "checked" and Verify.indicatorValue eq "")>checked</cfif>>
				   
				 <cfelse>
				  				  
				   <cfif Verify.indicatorValue eq "1" or attributes.value eq "checked">
				   <img src="#SESSION.root#/Images/checkbox-on1.gif" alt="" border="0">
				   <cfelse>
				   
				   <!---  N/A --->
				   </cfif>				   				  
				 
				 </cfif>  				   
				   
				  </td>
				  <td>
				    <table  border="0" cellspacing="0" cellpadding="0">
					<tr><td>
					<cfif ListingIcon neq "">
					<img src="#SESSION.root#/Images/#listingIcon#" alt="#Description#" border="0" align="absmiddle">
					<b>
					</cfif>
					<cfif attributes.status lt "2">
						<font color="#listingcolor#">#DescriptionQuestion#
					<cfelse>	
					 <cfif Verify.indicatorValue eq "1" or attributes.value eq "checked">				
						#Description#
					 </cfif>	
					</cfif>
				    </td>
				    <td>
				    <cfif attributes.status lt "2">
				     	<cf_helpfile code = "TravelClaim" 
					              class = "Indicator" 
								  id = "#Code#"
								  display = "icon">
					</cfif>			  
				    </td>
					</tr>
					</table>
				  </td>	
			 </tr>	
			 </table>	   
				   
			</cfcase>	
		
			<cfcase value="List">
			
			 <table cellspacing="0" cellpadding="0">
			 <tr><td align="left">
			   
			   #DescriptionQuestion# 
			   
			   <cfif attributes.status lte "1" and attributes.editclaim eq "1">
			   						
						   			  			   			   							
				   <select id="#fld#"
			        name="#fld##Code#"
			        onChange="javascript:verify('#fld##Code#',this.value)">
				   <cfloop index="itm" list="#LineList#" delimiters=",">
				     <option value="#itm#" <cfif Verify.IndicatorValue eq Itm or Verify.IndicatorValue neq "">selected</cfif>>#itm#</option>				 
				   </cfloop>  
				   </select>
				   
				   <cfif Verify.IndicatorValue eq Itm>
					    <cfset caller.returnval = "regular">
				   <cfelse>
			        	<cfset caller.returnval = "hide">
				   </cfif>	
			   
			   <cfelse>
			   
					&nbsp;<b><cfif Verify.IndicatorValue eq "">--<cfelse>#Verify.IndicatorValue#</cfif></b>
					
					<cfif Verify.IndicatorValue eq "Yes">
					    <cfset caller.returnval = "regular">
				    <cfelse>
			        	<cfset caller.returnval = "hide">
				    </cfif>	
				   	
			   </cfif>
			     	   		   		 			  		   
			 
			   </td>
			   </tr>
						   
			   </tr>
			   </table>				   
			</cfcase>	      
			   
		</cfswitch>	   
		
		</td>
	</tr>
				
	</cfoutput>	
			
</table>		