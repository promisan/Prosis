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
<cfparam name="CLIENT.payables" default="">

<cfif url.mode eq "AP">
    <!---
    <cfset journalfilter = "'Payables','Payment','DirectPayment'">
	--->
	<cfset journalfilter = "'Payables'">
<cfelse>
    <cfset journalfilter = "'Receivables'">
</cfif>	
		
<cfquery name="getAging"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   Days,
			 ROUND(SUM(AmountOutstanding)/1000,1) as AmountOutstanding 			 
	FROM     Inquiry_#url.mode#_#session.acc# P
	 		 <cfif client.payables eq "">
				   WHERE 1=1
				   <cfelse>
		         #PreserveSingleQuotes(Client.Payables)#	
				 </cfif>
	GROUP BY Days		
</cfquery>

<cfquery name="total" dbtype="query">
   SELECT   SUM(AmountOutstanding)/1.5 as Amount
	FROM getAging
</cfquery>
		

<table width="100%"align="center">

<tr><td height="20" class="labelmedium" style="padding-left:4px"><cf_tl id="Aging Analysis">in 000s</td></tr>

<tr><td align="center" valign="top">	

<cftry>
		
<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">

<cfchart style = "#chartStyleFile#" format="png"
           chartheight="160"
           chartwidth="480"
           showxgridlines="yes"
           showygridlines="yes"			   
		   scaleTo="#total.amount#"		   		   
		   font="Calibri" fontsize="14" 
           seriesplacement="default" 		                
           labelmask="##"     
		   zoom="5"                         	                 
           url="javascript:Prosis.busy('yes');ptoken.navigate('InquiryListing.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&filter=aging&value=$ITEMLABEL$','listbox')">
  
	   <cfchartseries type="bar" seriescolor="000000" datalabelstyle="value" colorlist="##000000,##5DE8D8,##CCCA6A,##FFFF00,##FF8040,##FF0000">  
   
     <!--- near future --->
	  
		<cfquery name="Aging" dbtype="query">
			SELECT SUM(AmountOutstanding) as Outstanding
			FROM   getAging 
			WHERE  Days <= 0
		</cfquery>
		
		<cfif Aging.Outstanding eq "">
		  <cfset val = "0">
		<cfelse>
		  <cfset val = Aging.Outstanding>
		</cfif>
	  	  	  	  
	    <cfchartdata item="Upcoming" value="#val#">
	  
	   <!--- less than 7 --->
	  
		<cfquery name="Aging" dbtype="query">
			SELECT SUM(AmountOutstanding) as Outstanding
			FROM   getAging 
			WHERE  Days > 0 AND Days <= 30
		</cfquery>
		
		<cfif Aging.Outstanding eq "">
		  <cfset val = "0">
		<cfelse>
		  <cfset val = Aging.Outstanding>
		</cfif>
	  	  	  	  
	  <cfchartdata item="1-30d" value="#val#">
	  	
	  <!--- over 7 days --->	  
	 
	  <cfquery name="Aging" dbtype="query">
			SELECT SUM(AmountOutstanding) as Outstanding
			FROM   getAging 
			WHERE  Days > 31 AND Days <= 60
	  </cfquery>	 
		
	  <cfif Aging.Outstanding eq "">
		  <cfset val = "0">
	  <cfelse>
		  <cfset val = Aging.Outstanding>
	  </cfif>	 
	  	  
	  <cfchartdata item="31-60d" value="#val#">
	  
	  <cfquery name="Aging" dbtype="query">
			SELECT SUM(AmountOutstanding) as Outstanding
			FROM   getAging
			WHERE  Days > 61 AND Days <= 90
		</cfquery>	 		
		  
	  <cfif Aging.Outstanding eq "">
		  <cfset val = "0">
	  <cfelse>
		  <cfset val = Aging.Outstanding>
	  </cfif>	 
		
	  <cfchartdata item="61-90d" value="#val#">
	  
	 <!--- 21 days --->
	  
	  <cfquery name="Aging" dbtype="query">
			SELECT SUM(AmountOutstanding) as Outstanding
			FROM   getAging
			WHERE  Days > 91 AND Days <= 180
		</cfquery>	  
						
		 <cfif Aging.Outstanding eq "">
		  <cfset val = "0">
		<cfelse>
		  <cfset val = Aging.Outstanding>
		</cfif>	
			  
	  <cfchartdata item="91-180d" value="#val#">
	  	  	  
		<cfquery name="Aging" dbtype="query">
		SELECT SUM(AmountOutstanding) as Outstanding
		FROM   getAging
		WHERE  Days > 181
		</cfquery>	 
		
		<cfif Aging.Outstanding eq "">
		  <cfset val = "0">
		<cfelse>
		  <cfset val = "#Aging.Outstanding#">
		</cfif>	 
	  
	  <cfchartdata item="Over 180d" value="#val#">
	
   </cfchartseries>	  
 
</cfchart>

<cfcatch></cfcatch>

</cftry>

</td>
</tr>
</table>