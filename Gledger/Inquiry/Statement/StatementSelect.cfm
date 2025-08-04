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

<cf_screentop height="100%" label="Financial Statement" scroll="no" html="No" jquery="Yes" busy="busy10.gif">

<cfajaximport tags="cfdiv,cfform">

<!--- blockEvent="rightclick" --->

<cfquery name="MissionSelect" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_Mission
	WHERE Mission IN (SELECT Mission 
	                  FROM Ref_MissionModule 
					  WHERE SystemModule = 'Accounting')
	AND   Mission IN (SELECT Mission 
	                 FROM Accounting.dbo.Ref_ParameterMission)	
    AND   Mission IN (SELECT Mission FROM Accounting.dbo.TransactionHeader)							 			  	
</cfquery>

<cfparam name="URL.Mission" default="">

<cfloop query="MissionSelect">

	<cfinvoke component="Service.Access"
			   Method="RoleAccess"
			   Role="'AccountManager'"
			   Mission="#Mission#"				 				   
			   ReturnVariable="Access">		
			   
	<cfif Access eq "GRANTED">	

		<cfset url.mission = MissionSelect.Mission>
		
	</cfif>		   

</cfloop>

<cfif url.mission eq "">

  <cf_message message="Problem you do not have access to this function" return="close">
  <cfabort>

</cfif>

<!--- horizontal cols --->

<cfquery name="Category"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Accounting.dbo.Ref_GLCategory
	ORDER BY ListingOrder
</cfquery>

<cfparam name="client.statementrep" default="pl">
<cfparam name="URL.Report" default="#client.statementrep#">

<cfparam name="client.statementlay" default="vertical">

<cfparam name="client.statementper" default="">
<cfparam name="URL.Period" default="#client.statementper#">

<cfif Category.recordcount eq "1">
	<cfparam name="URL.report" default="balance">
<cfelse>
	<cfparam name="URL.report" default="pl">
</cfif>

<cfquery name="Parameter"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Ref_ParameterMission
WHERE   Mission = '#URL.Mission#' 
</cfquery>

<cfif Parameter.EnableAllPeriod eq "1">

	<cfset period = "All">
	
<cfelse>

	<cfif URL.Period is "">
		<cfset period = "#Parameter.CurrentAccountPeriod#">
	<cfelse>
  		<cfset period = "#URL.Period#">
	</cfif>
	
</cfif>

<cf_dialogLedger>
<cf_calendarscript>
<cf_mobileGraphScripts>

<cfoutput>
	
	<script language="JavaScript">
	
	    function setaccountperiod(mis) {
		
		    
			per = document.getElementById('period').value
    		rep = document.getElementById('report').value	
			_cf_loadingtexthtml='';	
			ptoken.navigate('getAccountPeriod.cfm?period='+per+'&mission='+mis+'&report='+rep,'periodselectbox') 
		
		}
				
		function reloadalert() {
		   
			_cf_loadingtexthtml='';
			container 	= document.getElementById('alertme');
			if(container!=null){
				try{
				ptoken.navigate('setApply.cfm?ts=#getTickCount()#','alertme')
		   		} catch(e) {}				
			}
		}
		
		function reload(mode,accountperiod) {		
				
			_cf_loadingtexthtml='';	
		    mis = document.getElementById('mission').value											
			try {					
	        per = document.getElementById('period').value
			} catch(e) { per = accountperiod }
			rep = document.getElementById('report').value										
																								
			if (mode != "0") { 
									 
			  // new data
			  Prosis.busy('yes')
			  ptoken.navigate(rep+'/'+rep+'Query.cfm?ts=#getTickCount()#&mode='+mode+'&mission='+mis+'&period='+per,'mainbox','','','POST','criteria');	   
						  
			} else {	
			 
			  // no new data
			  Prosis.busy('yes')					 
			  try { 
				    document.getElementById("fileno").value 
					ptoken.navigate(rep+'/'+rep+'View.cfm?ts=#getTickCount()#&fileno='+document.getElementById("fileno").value+'&mission='+mis+'&period='+per,'mainbox','','','POST','criteria'); 					
				} catch(e) {				
					ptoken.navigate(rep+'/'+rep+'Query.cfm?ts=#getTickCount()#&mode='+mode+'&mission='+mis+'&period='+per,'mainbox','','','POST','criteria');					
				}  		 	  
			  
			}	
										   	  			
		}
				
		function transactionperiod() {
		
			mis = document.getElementById('mission').value						
			rep = document.getElementById('report').value	
			per = document.getElementById('period').value	
			_cf_loadingtexthtml='';	
			ptoken.navigate('getTransactionPeriod.cfm?ts=#getTickCount()#&mission='+mis+'&accountperiod='+per+'&report='+rep,'boxtransactionperiod')
		
		}

		function toggleSection(sel) {
			if ($(sel).first().is(':visible')) {
				$(sel).hide();
			} else {
				$(sel).show();
			}
		}
		
	</script>

</cfoutput>

<cfoutput>

<cf_LayoutScript>
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
				
		<cf_ViewTopMenu label="Financial Statement" background="gray">
		
	</cf_layoutarea>		
						  
		<cf_layoutarea 
		    position    = "left" 
			name        = "treebox" 
			maxsize     = "300" 		
			size        = "230" 
			minsize     = "230"
			collapsible = "true" 
			splitter    = "true"
			overflow    = "scroll">		
			
			<cfform method="POST" style="height:98%" name="criteria" id="criteria">	
			
			<table width="100%" height="100%">
			
			<tr><td height="40" align="center" style="padding-left:10px">
			
					<table width="99%" class="formspacing" align="center">
						
						<tr>
						
						<TD>
							
							<select name="mission" 
							    style="width:200px;font-size:18px;height:30px;border:0px;background-color:f1f1f1" 
								id="mission" 
								class="regularxxl" 
								onChange="setaccountperiod(this.value)">
															
							    <cfloop query="MissionSelect">
								
									<cfinvoke component="Service.Access"
										   Method="RoleAccess"
										   Role="'AccountManager'"
										   Mission="#Mission#"				 				   
										   ReturnVariable="Access">		
										   
										<cfif Access eq "GRANTED">		
											<option value="#Mission#" <cfif url.mission eq mission>selected</cfif>>#Mission#</option>
																					
										</cfif>
										
								</cfloop>
								
							</select>
								
						</td>
						
						</tr>
									
						
						<tr>
						
						<td id="periodselectbox">			
								   
							<cfinclude template="getAccountPeriod.cfm">
										
						</td>
						
						</tr>
						
						<tr>
								
						<td>		
													
							<select name="report" id="report" style="background-color:f1f1f1;border:0px;width:200px;font-size:18px;height:30px" class="regularxxl" size="1"
							  onChange="Prosis.busy('yes');transactionperiod()">
							    
								<OPTION value="pl"      <cfif URL.report is "pl">selected</cfif>> <cf_tl id="Income Statement">
								<OPTION value="balance" <cfif URL.report is "balance">selected</cfif>> <cf_tl id="Balance Sheet">
								<OPTION value="fund"    <cfif URL.report is "fund">selected</cfif>><cf_tl id="Cash flow Statement">
							</select> 
							
						</td>		
						
						</tr>						
																		
					</table>
			
			</td>
			</tr>
						
			<tr><td height="100%" style="padding-left:14px">
			
			<cf_divscroll style="text-align: center;height:100%" id="boxtransactionperiod">			
			   
					<cfinclude template="getTransactionPeriod.cfm">				
			
			</cf_divscroll>	
			
			</td>
			</tr>
			
			 </cfform>
				
		</cf_layoutarea>
		
		<cf_layoutarea position="center" name="box">
			<cf_divscroll style="text-align: center;height:99%" id="mainbox"/>		
		</cf_layoutarea>		
		
	</cf_layout>	
		
	</cfoutput>		


