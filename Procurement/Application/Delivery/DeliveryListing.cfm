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
<cf_calendarScript>

<cfquery name="PO" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT  * 
	 FROM   Purchase
	 WHERE PurchaseNo = '#URL.PurchaseNo#'	
</cfquery>

<!--- status --->

<cfquery name="Status" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT  * 
	 FROM   PurchaseLine
	 WHERE PurchaseNo = '#URL.PurchaseNo#'	
	 AND DeliveryStatus < '3'
</cfquery>	

<cfif status.recordcount eq "0">
 <cfset open = 0>
<cfelse>
 <cfset open = 1> 
</cfif>

<cf_screentop height="100%" html="No" layout="webapp" label="Shipping and Delivery Tracking" close="parent.ColdFusion.Window.hide('deliverdialog')" banner="gray">
	
	<cfparam name="URL.PurchaseNo" default="">
	
	<cfquery name="Transport" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		 FROM       Ref_TransportTrack
		 WHERE      TransportCode = '#PO.TransportCode#' 
		 AND        Operational = 1
		 ORDER BY   TrackingOrder	    	
	</cfquery>

	<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="6"></td></tr>
	<tr class="hide"><td colspan="5"><iframe name="result" id="result"></iframe></td></tr>
	
	<cfform action="DeliveryListingSubmit.cfm?purchaseno=#url.purchaseno#&transportcode=#PO.TransportCode#"
        method="POST"
        target="result">
		
		<tr class="labelmedium line">
		    <td></td>
			<td><cf_tl id="Stage"></td>
			<td><cf_tl id="Planning"></td>
			<td><cf_tl id="Actual"></td>
			<td><cf_tl id="Memo"></td>
		</tr>
			
		<cfoutput query="Transport">
		
			<cfquery name="Current" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT     *
				 FROM       PurchaseTracking
				 WHERE      PurchaseNo    = '#PO.PurchaseNo#' 
				 AND        TrackingId    = '#TrackingId#'	  	
			</cfquery>
				
			<tr class="labelmedium linedotted">	
			    <td>#currentrow#.</td>			
				<td style="padding-right:3px">#Description#:</td>
				
				<td>
				
					<cfif open eq "1">
				
				 	 <cf_intelliCalendarDate9
						FieldName="DatePlanning_#Currentrow#" 
						class="regularxl"
						Default="#dateformat(Current.DatePlanning,'#CLIENT.DateFormatShow#')#"
						AllowBlank="True">		
						
					<cfelse>
					
					 	#dateformat(Current.DatePlanning,'#CLIENT.DateFormatShow#')#
						
					</cfif>	
						
				</td>	
				
				<td>
				
				   <cfif open eq "1">
				
				 	 <cf_intelliCalendarDate9
						FieldName="DateActual_#Currentrow#" 
						class="regularxl"
						Default="#dateformat(Current.DateActual,CLIENT.DateFormatShow)#"
						AllowBlank="True">	
						
					<cfelse>
					
					 	#dateformat(Current.DateActual,'#CLIENT.DateFormatShow#')#
						
					</cfif>	
										
				</td>	
				<td>
				
					<cfif open eq "1">
					
					   <input type="text"
				    	   name="TrackingRemarks_#Currentrow#"
						   id="TrackingRemarks_#Currentrow#"
					       value="#Current.TrackingRemarks#"
					       size="40"
					       maxlength="100"
					       class="regularxl">
						   
					<cfelse>
					
						#Current.TrackingRemarks#
					
					</cfif>	   
						   
				</td>			
			</tr>
		
		</cfoutput>
				
		<cfif open eq "1">
		
			<tr>
			
			   <td colspan="5" height="40" align="center">
			   
				   <table cellspacing="0" cellpadding="0" class="formspacing">
				    <tr>
					<td>
					<cfinput type="button" name="Close" id="Close" value="Close" class="button10g" onclick="parent.ProsisUI.closeWindow('deliverdialog')">
					</td>
					<td>
					<cfinput type="submit" name="Save" id="Save"  value="Save"  class="button10g">
					</td>
					</tr>
				   </table>
				   
			   </td>		   
		   </tr>
	   
		</cfif>
		
	</cfform>	
	
	</table>

<cf_screenbottom layout="innerbox">
