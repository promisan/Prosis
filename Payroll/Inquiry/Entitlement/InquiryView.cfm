<cfquery name="Calculation" 
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT 	*
	  FROM 		SalarySchedulePeriod S
	  WHERE 	S.CalculationId   = '#URL.ID2#'  
</cfquery>

<cf_screentop
   label="#Calculation.SalarySchedule# #Dateformat(Calculation.PayrollStart,CLIENT.DateFormatShow)# - #DateFormat(Calculation.PayrollEnd,CLIENT.DateFormatShow)#" 
    layout="webapp" html="no" scroll="No" jquery="Yes">

<cf_dialogStaffing>
<cf_Listingscript>
 
<cfoutput>
	<script>
		function detail(id,id1,id2,itm) {	 
		     Prosis.busy('yes')
			_cf_loadingtexthtml='';	        
			ptoken.navigate('RecapItem.cfm?ID='+id+'&ID1='+id1+'&ID2='+id2+'&ID3='+itm+'&systemfunctionid=#url.systemfunctionid#','mainContainer')	
		}

		function listing(id,id1,id2,id3,itm) {	
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';	   
			ptoken.navigate('RecapItemContent.cfm?ID='+id+'&ID1='+id1+'&ID2='+id2+'&ID3='+id3+'&ID4='+itm+'&systemfunctionid=#url.systemfunctionid#','listingcontent')	
		}
	</script>	
</cfoutput>
			
<table style="height:100%" width="99%" align="center">
<tr><td id="content" valign="top">
	<cfinclude template="RecapBase.cfm">		
</td></tr>
</table>
				
	