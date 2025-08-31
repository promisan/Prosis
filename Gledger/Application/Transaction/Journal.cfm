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
<cfparam name="URL.OrgUnit"           default="0">
<cfparam name="URL.JournalBatchNo"    default="">
<cfparam name="URL.Journal"           default="0">
<cfparam name="URL.IDStatus"          default="">
<cfparam name="URL.Find"              default="">
<cfparam name="URL.Month"             default="">
<cfparam name="URL.Print"             default="0">
<cfparam name="URL.ReferenceId"       default="">
<cfparam name="URL.ReferenceOrgUnit"  default="">

<cf_screentop html = "no" jquery="yes">

<cf_annotationScript>
<cf_dialogLedger>
<cf_dialogMaterial> 
<cf_dialogstaffing> 

<cfset CLIENT.OrgUnit = URL.OrgUnit>

<!--- Query returning search results --->	

<cfset url.find = trim(url.find)>
 
<!--- loading improvement in which we only show pages that are needed, as once we have
70.000 records it opens to slow of course --->

<cfquery name="OrgUnit" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Organization
	 WHERE  OrgUnit = '#URL.OrgUnit#' 
</cfquery>

<!--- obtain the base data to show in header and lines --->
<cfinclude template="JournalListingQuery.cfm">

		
<cfif TransactionListing.AccountPeriod eq "">
	
	<cfquery name="Period" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT * 
		  FROM  Period 	  
		  WHERE ActionStatus = '0'	  
	  </cfquery>

<cfelse>

<!---
<cfquery name="Period" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT * 
		  FROM  Period 	  
		  WHERE ActionStatus = '0'	  
	  </cfquery>
	  --->

	<cfquery name="getPeriod" dbtype="query">
		SELECT DISTINCT AccountPeriod
		FROM   TransactionListing
	</cfquery>
			
	<cfquery name="Period" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT * 
		  FROM  Period 	  
		  WHERE AccountPeriod IN (#quotedvalueList(getPeriod.AccountPeriod)#) 
	  </cfquery>
	
	    
</cfif>  

<cfoutput>

	<script>
	
	function reloadForm(page,status) {
		   
	    Prosis.busy('yes')
		_cf_loadingtexthtml='';	
				
		if (page) { pg = page } else { pg = 1 }			
			
		sr = document.getElementById('group').value;	
		pe = document.getElementById('period').value;		
		fi = document.getElementById('filtersearch').value;			
		if (status) { st = status  } else { st = document.getElementById('idstatus').value }	   
			
	    se = document.getElementById('monthselect').value;
		bt = document.getElementById('journalbatchno').value;		
				
	    ptoken.navigate('JournalListingDetail.cfm?query=1&referenceid=#url.referenceid#&journalbatchno='+bt+'&month='+se+'&find='+fi+'&Mission=#URL.Mission#&OrgUnit=#URL.OrgUnit#&IDSorting=' + sr + '&Page=' + pg + '&Journal=#URL.Journal#&Period=' + pe + '&IDStatus=' + st,'journalcontent');		
		
	}
	
	function myprint(group,page,period,status,filter) {
	    se = document.getElementById("monthselect").value
		bt = document.getElementById("journalbatchno").value
	    ptoken.open("Journal.cfm?referenceid=#url.referenceid#&print=1&journalbatchno="+bt+"&month="+se+"&find="+filter+"&Mission=#URL.Mission#&OrgUnit=#URL.OrgUnit#&IDSorting=" + group + "&Page=" + page + "&Journal=#URL.Journal#&Period=" + period + "&IDStatus=" + status,"_blank", "left=20, top=20, width=850, height=800, menubar=yes,status=yes, toolbar=no, scrollbars=yes, resizable=no");
	}
	
	function search(e) {
	  	  
	   keynum = e.keyCode ? e.keyCode : e.charCode;	   	 						
	   if (keynum == 13) {
	      document.getElementById("locate").click(); }		
	   }
	
	</script>		
	
</cfoutput>  

<cfinclude template="JournalListing.cfm">  