
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

<table width="100%" cellspacing="0" cellpadding="0" align="center">

<tr><td height="20" class="labelmedium" style="padding-left:4px"><cf_tl id="Aging Analysis">in 000s</td></tr>

<tr><td align="center" valign="top">	

<cftry>
		
<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">

<cfchart style = "#chartStyleFile#" format="png"
           chartheight="160"
           chartwidth="480"
           showxgridlines="yes"
           showygridlines="no"
		   font="Calibri" fontsize="13"
           seriesplacement="default"
           backgroundcolor="ffffff"
           databackgroundcolor="FfFfFf"          
           labelmask="##"                    
           show3d="no"   		      
           pieslicestyle="sliced"
           url="javascript:ColdFusion.navigate('InquiryListing.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&filter=aging&value=$ITEMLABEL$','listbox')">
  
		   <cfchartseries type="bar" seriescolor="E85DA2" datalabelstyle="value" paintstyle="plain" colorlist="##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">  
   
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