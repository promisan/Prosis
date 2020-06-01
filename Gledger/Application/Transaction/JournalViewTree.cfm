
<cfoutput>

<script language="JavaScript1.2">

function updatePeriod(per) {
 window.PeriodSelect.value = per
 <cfoutput>
	right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
 </cfoutput>
}

function updateSub(per) {
	window.SubSelect.value = per
	<cfoutput>
	right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
	</cfoutput>
}

function updateoption(per,subperiod) {

	window.option.value = per
	right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
	se = document.getElementsByName('subbox')

	count=0
	while (se[count]) {
		if (subperiod == 'yes') {
	    	se[count].className = 'regular'
		  } else {
		    se[count].className = 'hide'
		  }
	count++ 
	  }
}

</script>

</cfoutput>

<cfset Criteria = ''>

<table width="100%" height="100%" class="tree">

<tr><td height="100%" valign="top">

	<table width="96%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
						
			<cfquery name="Parameter" 
			  datasource="AppsLedger" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT * 
				  FROM   Ref_ParameterMission
				  WHERE  Mission = '#URL.Mission#'
			  </cfquery>
			
			  <cfquery name="Period" 
			  datasource="AppsLedger" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT * 
				  FROM   Period 
				  WHERE  AccountPeriod >= (SELECT MIN(AccountPeriod) 
				                           FROM   TransactionHeader
										   WHERE  Mission = '#URL.Mission#')
			  </cfquery>
			  		  
			  
			<tr><td height="6"></td></tr>  
	  
	        <tr class="line">
	          <td> 
			  
			  <table>
			  <tr>
			  <td style="font-size:17px;padding-left:3px;height:41px" class="labelmedium"><cf_tl id="Fiscal Period">:</td>			  
			  <td>
			    <cfoutput>
	    	    <select name="Period" id="Period" class="regularxl" onchange="_cf_loadingtexthtml='';ptoken.navigate('JournalViewTreeShow.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&glcategory=Actuals&Period=' + this.value,'treeshow')">
		        <cfloop query = "Period"> 
				    <option value="#AccountPeriod#" <cfif Parameter.CurrentAccountPeriod eq AccountPeriod>selected</cfif>>#Description#
					    <cfif Parameter.CurrentAccountPeriod eq AccountPeriod>&nbsp;[<cf_tl id="default">]</cfif>
					</option>
	            </cfloop> 
	    		</select>	
				</cfoutput>
				</td></tr></table>
				
			  </td>
	        </tr>
					
			
			<cfoutput>
			
			<tr class="line"><td class="labelmedium" style="font-size:16px;height:35px;padding-left:4px">			     
				    <a href="javascript:ptoken.open('JournalViewOpen.cfm?ID=LOC&Mission=#url.Mission#','right')"><cf_tl id="Extended Search"></a>				 							
			</td></tr>			 
			
			 <cfquery name="Cat" 
			  datasource="AppsLedger" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT * 
				  FROM   Ref_GLCategory
				  WHERE  GLCategory IN (SELECT GLCategory 
				                        FROM   Journal 
										WHERE  Mission = '#URL.Mission#')
			  </cfquery>
			  
			  <cfif cat.recordcount gte "2">
			  
				  <tr class="line"><td>
					  <table cellspacing="0" cellpadding="0" class="formpadding">
					  <tr class="labelmedium">
					  <td style="height:35px"></td>
					  
					  <cfloop query="Cat">
					  
						      <td class="labelit" style="padding-left:3px">
						        <input type="radio" class="radiol" name="glcategory" 
							     onclick="_cf_loadingtexthtml='';ptoken.navigate('JournalViewTreeShow.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&glcategory=#GLCategory#&Period=' + document.getElementById('Period').value,'treeshow')"
							     value="#GLCategory#" <cfif GLCategory eq "Actuals">checked</cfif>>
						  	  </td>
							  <td style="padding-left:4px;font-size:16px;font-weight:200;cursor:pointer" onclick="glcategory[#currentrow-1#].click()"><cf_tl id="#GLCategory#"></td>
							   
					  </cfloop>
					  
					  </tr>
					  </table>
				  </td></tr>
							  
			  </cfif>
			
	         </cfoutput>  
			
	<tr><td height="4"></td></tr>
	
	<tr><td valign="top" style="height:100%;padding-left:5px;padding-top:8px">
	
	  <cf_divscroll id="treeshow" style="height:100%">
	  	  		
		<cfset url.glcategory = "Actuals">
		<cfset url.period     = "#Parameter.CurrentAccountPeriod#">
		<cfinclude template   = "JournalViewTreeShow.cfm">
		
	  </cf_divscroll>	
		
	</td></tr>
		
	</table>

</td></tr>

</table>

