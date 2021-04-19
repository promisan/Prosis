
<!--- payables inquiry view --->

<!--- left a listing, right a total by journal and under it a graph by age --->
<!--- drill down to transaction --->

<cfparam name="url.mode" default="AP">

<cfif url.mode eq "AP">
    <!---
    <cfset journalfilter = "'Payables','Payment','DirectPayment'">
	--->
	<cfset journalfilter = "'Payables'">
<cfelse>
    <cfset journalfilter = "'Receivables'">
</cfif>	

<cf_tl id="Accounts #journalfilter#" var="label">

<cf_screentop height="100%" border="0" layout="webapp" jQuery="Yes"  scroll="no" html="No" label="#url.mission# #label#" MenuAccess="Yes">

<cf_listingscript>
<cf_layoutscript>
<cf_dialogledger>

<cfoutput>
	
	<script>
	
	  _cf_loadingtexthtml='';		
	
	  function reload(action,person) {  	 
	      Prosis.busy('yes')	 
	      ptoken.navigate('InquiryQuery.cfm?action='+action+'&personno='+person+'&mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#','result','','','POST','myaccountingform')	
	  }
	 
	  function gldetail(acc) {  
		  _cf_loadingtexthtml='';	 
		  ptoken.navigate('InquiryAccount.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&account='+acc,'listbox')	    
	  }
	
	</script>
</cfoutput>

<cfset client.payables = "">

<cfajaximport tags="CFCHART">

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
   	
	<cf_layoutarea 
          position="header"
          name="controltop">	
		  
		  	 <cfinclude template="InquiryMenu.cfm">		  
					 
	</cf_layoutarea>		
	
	<cf_layoutarea size="520" maxsize="30%" minsize="30%"  
       position="left" name="myleft" collapsible="true" splitter="true">	
	   
	   		<cf_divscroll style="width:100%;height:100%">   
			
				<table width="97%" height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				    <tr><td height="5" bgcolor="ffffff"></td></tr>
																				
					<tr><td valign="top" bgcolor="ffffff">
															
					<table width="97%" align="center">
					
						<tr class="hide"><td height="1" class="line" id="result"></td></tr>
												
						<tr><td bgcolor="ffffff" align="center" style="padding:2px;padding-bottom:4px;" valign="top">	
							<cfinclude template="ShowAccount.cfm">						
						</td>
						</tr>	
						
						
															
						<tr>
						<td valign="top" height="30" bgcolor="ffffff">
							<cfinclude template="ShowJournal.cfm">
						</td>
						</tr>	
						
						
						<tr><td valign="top" style="padding:1px;width:520" id="graph">						
							<cfinclude template="ShowAging.cfm">
						</td></tr>													
						
						<tr><td bgcolor="ffffff" height="100" align="center" valign="top" id="payee">
						    <cfinclude template="ShowPayee.cfm">						
						</td></tr>	
						
						
					</table>			
					
					</td>
					</tr>
					
				</table>
				
			</cf_divscroll>	
			
</cf_layoutarea>

<cf_layoutarea  style="height:100%" size="70%" maxsize="70%" minsize="70%" position="center" name="mylisting">

	<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
	<tr><td valign="top" height="100%" style="padding:5px">		
		<cf_divScroll overflowx="yes" id="listbox">		
			<cf_securediv bind="url:InquiryListing.cfm?init=1&mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#" 
			style="height:100%; width:100%;">				
		</cf_divScroll>	
	</td></tr>
	</table>	

</cf_layoutarea>	

<cf_layoutarea  style="height:100%" size="200" collapsible="true" position="right" initcollapsed="yes" name="person">
	 <cfinclude template="ShowPerson.cfm">
 </cf_layoutarea>	

</cf_layout>

