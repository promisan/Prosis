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
<!---
<cf_screentop banner="gray" layout="webapp" label="Travel costs" html="Yes" scroll="no" user="no">
--->

<cfquery name="Detail" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLineTravel 
	WHERE RequisitionNo = '#URL.ID#'
	<cfif url.id2 neq "new">
	AND   DetailId = '#URL.ID2#' 
	<cfelse>
	AND 1=0
	</cfif>
</cfquery>

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    Currency
	WHERE   EnableProcurement = 1	
</cfquery>

<cfquery name="Category" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    Ref_ClaimCategory
	WHERE   ListingOrder < '99' 
	AND     RequirerequestLine = 1
	ORDER BY ListingOrder, Description
</cfquery>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLine
	WHERE RequisitionNo = '#URL.ID#'
</cfquery>

<cfoutput>

<table width="99%" align="center" height="100%">

<tr class="hide"><td id="travelservice"></td></tr>

<tr><td valign="top">

<cfform method="POST" name="trvedit" onsubmit="return false">

<table width="93%" align="center" class="formpadding">

<tr><td height="4"></td></tr>
<TR>
	
	<td class="labelmedium" width="110"><cf_tl id="Cost">:</td>
	<td colspan="3" width="75%">
	
		  <select name="claimcategory" id="claimcategory" class="regularxl" onchange="travelitem('category',this.value,'','')">
			  <cfloop query="Category">				  
				   <option value="#code#" <cfif detail.claimcategory eq code>selected</cfif>>
				   #description#					   
				   </option>
			  </cfloop>
		  </select>
		  		  
		  <cfif detail.claimcategory neq "">
		    <cfset sel = detail.claimcategory>
		  <cfelse>
		  	<cfset sel = Category.code>
		  </cfif>
		  
		  <cfquery name="Check" 
		  datasource="AppsTravelClaim" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  	   SELECT * 
			   FROM   Ref_ClaimCategory	   
			   WHERE  Code   = '#sel#'			  	
		  </cfquery>
		  
		  <cfif check.RequestDays eq "0">
			  <cfset cl = "hide">
		  <cfelse>
		  	  <cfset cl ="regular">
		  </cfif>	  
		   
		  
	</td>
	</tr>
	
	<tr id="trvlocbox" class="#cl#">
	
	<td class="labelmedium"><cf_tl id="Location code">:</td>
	
	<td colspan="3">
	
	<cf_verifyOperational 
         datasource= "AppsPurchase"
         module    = "TravelClaim" 
		 Warning   = "No">
		 
	<cfif Operational eq "1"> 
			
		<cfquery name="Location" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   R.LocationCode, R.LocationCountry, R.LocationCode+'-'+R.Description as Description, N.Name
			FROM     Ref_PayrollLocation R INNER JOIN
		             System.dbo.Ref_Nation N ON R.LocationCountry = N.Code
			WHERE    LocationCountry IN (SELECT C.LocationCountry
										 FROM   Purchase.dbo.RequisitionLineItinerary AS I INNER JOIN
						                        TravelClaim.dbo.Ref_CountryCity AS C ON I.CountryCityId = C.CountryCityId 
										 WHERE  RequisitionNo = '#url.id#')				 
			ORDER BY N.Name, R.LocationCode		   
		</cfquery>
		
		<cfif location.recordcount eq "0">
		
			<cfquery name="Location" 
			datasource="AppsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   R.LocationCode, R.LocationCountry, R.LocationCode+'-'+R.Description as Description, N.Name
				FROM     Ref_PayrollLocation R INNER JOIN
			             System.dbo.Ref_Nation N ON R.LocationCountry = N.Code			
				ORDER BY N.Name, R.LocationCode		   
			</cfquery>
		
		</cfif>
		
		<cfselect name   = "locationcode" id="locationcode"
			    group    = "Name" 
				queryposition="below"
				onchange = "travelitem('location',this.value,'','')"
				query    = "Location" 
				class    = "regularxl"
				value    = "LocationCode" 
				display  = "Description" 
				selected = "#Detail.LocationCode#" 
				visible  = "Yes" 
				enabled  = "Yes">
				
				<option value="">--Select--</option>
				
				</cfselect>
	
	<cfelse>
		
	  	   <input type   = "Text"
		       name      = "locationcode"	
               id        = "locationcode"	
			   value     = "#detail.locationcode#"	       
			   style     = "text-align:center"
		       required  = "Yes"
		       size      = "10"
		       maxlength = "10"
		       class     = "regularxl">
			   
	</cfif>		   
					   	  
	</td>
	</tr>
	
	<tr id="trvdatebox" class="#cl#">
	<td class="labelmedium"><cf_tl id="Period">:</td>
	
	<td>
	
	     <cfif detail.DateEffective eq "">
				<cfset str = "">
		 <cfelse>
				<cfset str = "#Dateformat(detail.DateEffective, CLIENT.DateFormatShow)#">
		 </cfif>
				
		 <cfif detail.DateExpiration eq "">
				<cfset end = "">
		 <cfelse>
				<cfset end = "#Dateformat(detail.DateExpiration, CLIENT.DateFormatShow)#">
		 </cfif>		
		
		<table>
		<tr>
		<td>
			
		<cf_intelliCalendarDate10
            FieldName      = "CostPeriod"
            DateValidStart = "#str#"
            DateValidEnd   = "#end#"
            startLabel     = "From"
            endLabel       = "To"
			OnChange       = "changeDate"
			ajax           = "Yes">		
												
		</td>		
		</tr>
		</table>
		
	</td>
	
	<tr id="trvdaysbox">	
	<td class="labelmedium"><cf_tl id="Days">/<cf_tl id="Quantity">:</td>		  
	<td>
	
	<cfif detail.quantity eq "">
		
		      <cfinput type="Text"
			   id="quantity"
		       name="quantity"
			   onchange="travelitem('location',getElementById('locationcode').value,getElementById('currency').value,getElementById('currencyrate').value)"
			   style="text-align: right;padding-right:4px" 		
			   value="1"	       
		       validate="float"
			   message="Please enter a correct number"
		       required="Yes"
		       size="5"
		       maxlength="10"
		       class="regularxl">
			   
	<cfelse>
	
		  <cfinput type="Text"
		       id="quantity"
		       name="quantity"
			   onchange="travelitem('location',getElementById('locationcode').value,getElementById('currency').value,getElementById('currencyrate').value)"
			   style="text-align: right;;padding-right:4px" 		
			   value="#detail.Quantity#"	       
		       validate="float"
			   message="Please enter a correct number"
		       required="Yes"
		       size="5"
		       maxlength="10"
		       class="regularxl">
	
	</cfif>		   
				   
	</td>
	</tr>
	
	<tr>
	
	<td class="labelmedium"><cf_tl id="Rate">
	
	<cfif detail.currency neq "">
			<CFSET cur = detail.currency>
		<cfelse>
			<CFSET cur = Line.RequestCurrency>
		</cfif>
	
	     <select name="currency" id="currency" class="regularxl" 
		   onchange="travelitem('location',getElementById('locationcode').value,this.value,getElementById('currencyrate').value)">
		  <cfloop query="Currency">				  
			<option value="#currency#" <cfif cur eq currency>selected</cfif>>#currency#</option>
		  </cfloop>
		  </select>
	
	:
	</td>
	
	<td>
	<table>
	<tr>
			
		<td>
	
			<cfinput type = "Text"
				       name        = "currencyrate"
					   id          = "currencyrate"
					   onchange    = "travelitem('location',getElementById('locationcode').value,getElementById('currency').value,this.value)"
					   style       = "text-align: right;" 			       
				       validate    = "float"
					   value       = "#detail.CurrencyRate#"
				       required    = "Yes"
					   message     = "Please enter a correct rate/amount"
				       size        = "10"
				       maxlength   = "10"
				       class       = "regularxl">
	
		</td>
		</tr>
		</table>
	</td>
	
	</tr>
	
	<tr id="trvmodabox" class="#cl#">
	
	<td class="labelmedium"><cf_tl id="Modality">:</td>		
		
	<td>
			<table>
			
			<cfquery name="Item" 
					datasource="AppsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Indicator 
					WHERE  Category   = 'DSA' 
					AND    Operational = 1
			</cfquery>
		
			<tr>
				
			<cfloop query="Item">  
				
				<cfquery name="Pointer" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM  RequisitionLineTravelPointer
							WHERE RequisitionNo = '#URL.ID#'
							<cfif url.id2 neq "new">
							AND   DetailId = '#URL.ID2#'
							<cfelse>
							AND 1=0
							</cfif>
							AND  IndicatorCode = '#Code#'
				</cfquery>
			
				<td>
				<input type="checkbox" class="radiol" name="IndicatorCode_#code#" id="IndicatorCode_#code#" value="1" <cfif Pointer.recordcount eq "1">checked</cfif>>
				</td>   
			
				<td style="padding-left:4px;padding-right:4px">#description#</td> 
				
			</cfloop>
			
		
				</tr>
				
			</table>
		
	</td>
	
	</tr>
	
	<tr>
	
	<td class="labelmedium"><cf_tl id="Percentage">:</td>
	<td>
	
	<table><tr>
	<td>
	
	<cfif detail.UoMPercentage eq "">
	    <cfset perc = "100">
	<cfelse>
		<cfset perc = detail.UoMPercentage>
	</cfif>
	
	<cfinput type="Text"
		       id="UoMPercentage"
		       name="UoMPercentage"
			   onchange="travelitem('location',getElementById('locationcode').value,getElementById('currency').value,getElementById('currencyrate').value)"
			   style="text-align: right;;padding-right:4px" 		
			   value="#perc#"	       
		       validate="float"
			   message="Please enter a correct number"
		       required="Yes"
		       size="3"
		       maxlength="3"
		       class="regularxl">
	</td>
	<td style="padding-left:3px">%</td>
	</tr>
	</table>
	</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Rate in"> <cfif Line.RequestCurrency neq "">#Line.RequestCurrency#<cfelse>#APPLICATION.BaseCurrency#</cfif>:</td>
		<td colspan="3">
		
		    <table><tr><td>
			
		     <cfinput type = "Text"
		       name        = "rate"
			   id          = "rate"
			   onchange="travelitem('location',getElementById('locationcode').value,getElementById('currency').value,getElementById('currencyrate').value)"			  
			   style       = "text-align: right;" 			       
		       validate    = "float"
			   value       = "#detail.UoMRate#"
		       required    = "Yes"
			   message     = "Please enter a correct rate/amount"
		       size        = "10"
		       maxlength   = "10"
		       class       = "regularxl">
			   
			   </td>
			   
			   <td style="padding-left:15px" class="labelmedium"><cf_tl id="Amount">:
			   <td style="padding-left:5px">
				   <input type = "Text"
			       name        = "amount"
				   id          = "amount"
				   style       = "text-align: right;" 			       
			       readonly
				   value       = "#detail.Amount#"
			       required    = "Yes"			  
			       size        = "10"
			       maxlength   = "10"
			       class       = "regularxl">
			   </td>
			   </tr></table>
		</td>
	</tr>
	
	<tr>
		<td valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Memo">:</td>
		<td colspan="3">
		
		   <textarea style="width:95%;font-size:14px;padding:3px;height:50px" class="regular" name="Memo">#detail.memo#</textarea>
		   
		</td>
	</tr>
	
	
	<tr><td height="1" colspan="4" class="line"></td></tr>
	
	<tr> 	 
		  			  								   
		<td colspan="4" align="center">
				
			<cfoutput>
			
				<input type="button"
				  onclick="ProsisUI.closeWindow('dialogtravel')"
				  value="Close" 				  
				  class="button10g">
				
				<input type="button"
				  onclick="travelvalidate('#url.id2#');"
				  value="Save" 				 
				  class="button10g">
				  
			 </cfoutput> 
				  
		</td>
				    
	</TR>	
				
</table>
		
</cfform>			

</td></tr>

</table>

</cfoutput>		

<cfset ajaxonload("doCalendar")>	

