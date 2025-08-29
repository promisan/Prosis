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
<cf_screentop height="100%" scroll="Yes" html="No" MenuAccess="context" jquery="yes">

<cfoutput>
	
<cf_dialogLedger>	
<cf_dialogPosition>
<cf_dialogOrganization>
<cf_calendarScript>

<script language="JavaScript">

function reloadForm(filter,group,page) {	
	 
	 des = document.getElementById("description").value	
     url = "TransactionListing.cfm?description="+des+"&ID=" + group + "&Page=" + page + "&ID2=" + filter;	
	 _cf_loadingtexthtml='';	
	 parent.Prosis.busy('yes') 		 
	 ptoken.navigate(url,'details')		
	
}

function search() {

    parent.Prosis.busy('yes')
	document.locateform.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
	
       url = "TransactionListingPrepare.cfm?"+
	         "&mission=#url.mission#"			 
	   ptoken.navigate(url,'details','','','POST','locateform')	
     }   					 
}

</script>

</cfoutput>

<cfparam name="URL.Mission" default="S">

<!--- Search form --->
   
<cfquery name="OrgUnit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT MissionOrgUnitId, OrgUnitName
	FROM   Organization
	WHERE  Mission = '#URL.Mission#'
	AND    OrgUnit IN (SELECT OrgUnit FROM Accounting.dbo.TransactionLine)
</cfquery>      
   
<cfquery name="Period" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT AccountPeriod
    FROM   Period
	WHERE  AccountPeriod IN (SELECT AccountPeriod FROM transactionHeader WHERE Mission = '#URL.Mission#')	
</cfquery>   


<cfquery name="Parent" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_AccountParent
</cfquery>
	
<table width="99%" border="0" height="100%" valign="middle" cellspacing="0" cellpadding="0" align="center" class="formpadding">
   
 <tr>
	<td width="100%" height="10" align="center" onclick="toggle(this,'show')" style="cursor: pointer;">
	
	<script language="JavaScript">
	
	function toggle(itm) {
	se = document.getElementById("search")
	if (se.className == "regular") {
	   
		se.className = "hide"
		se = document.getElementById("img1")
		se.className = "hide"
		se = document.getElementById("img2")
		se.className = "regular"
	} else {
	  	se.className = "regular"
		se = document.getElementById("img2")
		se.className = "hide"
		se = document.getElementById("img1")
		se.className = "regular"
	}
	}
		
	</script>
	
	<cfoutput>
	<img src="#SESSION.root#/Images/up2.gif" alt="Filter options" name="img1" id="img1" border="0" align="absmiddle" class="regular">
	<img src="#SESSION.root#/Images/down2.gif" alt="Filter options" class="hide" align="absmiddle" id="img2" border="0">
	</cfoutput>
	</td>
</tr>

<tr><td height="1" class="line"></td></tr>

<tr><td valign="top" height="100" id="search" class="regular" style="min-width:1000">
	
	<cfform style="height:100%" onsubmit="return false" name="locateform">

		<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
			<TR>
			<TD class="labelmedium"><cf_tl id="Period">:</TD>
					
			<td align="left" valign="top">
				<select name="AccountPeriod" id="AccountPeriod" size="1" class="regularxl">
				    <option value="" selected><cf_tl id="All"></option>
				    <cfoutput query="Period">
					<option value="'#AccountPeriod#'">#AccountPeriod#</option>
					</cfoutput>
			    </select>
			</td>	
			
			<TD class="labelmedium" style="padding-right:10px"><cf_tl id="Cost Center">:</TD>
								
					<td align="left" valign="top">
					<select name="orgunit" id="orgunit"  size="1" class="regularxl">
					    <option value="" selected><cf_tl id="All"></option>
					    <cfoutput query="OrgUnit">
						<option value="'#MissionOrgUnitId#'">#OrgUnitName#</option>
						</cfoutput>
					</select>
					</td>	
			
			</tr>
						
				<cfquery name="Journal" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT DISTINCT T.Journal, J.Journal+' '+J.Description as Description , J.Currency
				    FROM   TransactionHeader T, 
					       Journal J
					WHERE  T.Journal  = J.Journal
					AND    T.Mission  = '#URL.Mission#'
					
					<cfif getAdministrator(url.mission) eq "1">	
						<!--- no filtering --->
					<cfelse>	
					AND    T.Journal IN (SELECT ClassParameter 
						                 FROM   Organization.dbo.OrganizationAuthorization
						                 WHERE  UserAccount = '#SESSION.acc#' 
						                  AND   Role        = 'Accountant'
										  AND   Mission     = '#URL.Mission#') 
					</cfif>		
					ORDER BY J.Currency, T.Journal 
				</cfquery>
				
			<tr>
					<TD class="labelmedium"><cf_tl id="Journal">:</TD>
								
					<td align="left" valign="top">
								
					<cfselect name="journal" id="journal" size="1" group="Currency" queryposition="below" query="Journal" value="Journal" display="Description" visible="Yes" enabled="Yes" class="regularxl">
					    <option value="" selected><cf_tl id="All"></option>
					</cfselect>	
					  
					</td>	
							
					<TD class="labelmedium"><cf_tl id="Parent">:</TD>
								
					<td align="left" valign="top">
					<select name="parent" id="parent" size="1" class="regularxl">
					    <option value="" selected><cf_tl id="All"></option>
					    <cfoutput query="Parent">
						<option value="'#AccountParent#'">#Description#</option>
						</cfoutput>
					    </select>
					</td>	
			</tr>
			
			<TR>
			<TD class="labelmedium"><cf_tl id="Search for">:</TD>
			<TD colspan="3">	
			<input type="text" name="description" id="description" class="regularxl" value="" size="60">
			</TD>			
			</tr>
			
			<tr>
			
			<TD class="labelmedium" style="padding-right:20px;min-width:150">
						  
				<input type="radio" 
					  name="Party" 
					  onclick="document.getElementById('venbox').className='regular';document.getElementById('empbox').className='hide'"
					  value="Vendor" checked><cf_tl id="Vendor">
					  
				<input type="radio" 
					  name="Party" 
					  onclick="document.getElementById('empbox').className='regular';document.getElementById('venbox').className='hide'"		  
					  value="Employee"><cf_tl id="Staff">
					  
		    </TD>
				  
			<td colspan="3" height="22">
								   
				   <cfoutput> 
				   
				   <table cellspacing="0" cellpadding="0"><tr>
				   			  
					  <cfset ven = "regular">
					  <cfset emp = "hide">
					  		   
					  <td class="#ven#" id="venbox">
					  
					  		<table><tr>
							  
							  <td >
							  
							   <input type="text" name="referenceorgunitname1" id="referenceorgunitname1" onclick="this.value='';referenceorgunit.value=''" value="" class="regularxl" size="60" maxlength="60" readonly>
							   <input type="hidden" name="mission1" id="mission1">
						   	   <input type="hidden" name="referenceorgunit" id="referenceorgunit1" value="">
							   <input type="hidden" name="orgunitcode1" id="orgunitcode1">
						  	   <input type="hidden" name="orgunitclass1" id="orgunitclass1">
							   
							   </td>
							   
							   <td style="padding-left:1px">
					  
					         <img src="#SESSION.root#/Images/search.png" alt="Select" name="img1" 
									  onMouseOver="document.img1.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
									  onClick="selectorgN('','Administrative','referenceorgunit','applyorgunit','1')">				  			  
											  
							  </td>
							   
							   </tr></table>
					  </td>  
				   		   
				   	  <td class="#emp#" id="empbox">
					  
					  	  <img src="#SESSION.root#/Images/search.png" alt="Select" name="img9" 
									  onMouseOver="document.img9.src='#SESSION.root#/Images/button.jpg'" 
									  onMouseOut="document.img9.src='#SESSION.root#/Images/search.png'"
									  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
									  onClick="selectperson('webdialog','referencepersonno','indexno','lastname','firstname','referencename2','','')">
				   		 			
											
								<input type="text"    name="referencename2" id="referencename2"  onclick="this.value='';referencepersonno.value=''" class="regularxl" value="" size="60" maxlength="60" readonly style="text-align: left;">
								<input type="hidden"  name="indexno" id="indexno"   value="" class="disabled" size="10" maxlength="10" readonly style="text-align: center;">
								<input type="hidden"  name="referencepersonno" id="referencepersonno"  value="">
							    <input type="hidden"  name="lastname" id="lastname"  value="">
							    <input type="hidden"  name="firstname" id="firstname" value="">
							
							</td>
							
							<td id="process"></td>
								   
				   </tr></table>
				   
				   </cfoutput>		   
						   	
				  </td>
			
			</tr>
			
			
			
			<cfquery name="Currency" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    	SELECT DISTINCT Currency 
				FROM   TransactionHeader
			    WHERE  Mission = '#URL.Mission#'
			</cfquery>
			
			<cfquery name="Ledger" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    	SELECT * 
				FROM   Ref_ParameterMission
			    WHERE  Mission = '#URL.Mission#'
			</cfquery>
		
			<TR>
			<TD class="labelmedium"><cf_tl id="Transaction amount">:</TD>
			<TD colspan="3">
			
			<select name="currency" size="1" class="regularxl">
			    <option value="" selected>All</option>
			    <cfoutput query="Currency">
				<option value="'#Currency#'">#Currency#</option>
				</cfoutput>
			    </select>
			
			    <SELECT name="amountoperator" class="regularxl">
					<OPTION value="=">is
					<option value=">=" selected>>=
					
				</SELECT>
				<input type="text" class="regularxl" name="amount" value="0" size="15" style="text-align: right;">
				and 	
			    <SELECT name="amountoperatorto" class="regularxl">
					<OPTION value="=">is
					<OPTION value="<=" selected><=
				</SELECT>
				<input type="text"  class="regularxl" name="amountto" value="0" size="15" style="text-align: right;">
						
			</TD>		
			
			
			
			<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->
			
			<TR>
			<TD class="labelmedium"><cf_tl id="Transaction date between">:</TD>
			<TD colspan="3">	
			<table cellspacing="0" cellpadding="0">
			<tr><td>
			 <cf_intelliCalendarDate9
				FieldName="datestart" 
				class="regularxl"
				Default="01/01/2000"
				AllowBlank="True">	
				
			</TD>
			
			<TD class="labelmedium" style="padding-left:10px;padding-right:10px"><cf_tl id="and">:</TD>
			<TD>
			<cf_intelliCalendarDate9
				FieldName="dateend" 
				class="regularxl"
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="True">	
				
			</TD>
			</tr>
			</table>
			</td>
			</tr>
			
			<TR>
			<TD class="labelmedium"><cf_tl id="Posted between">:</TD>
			<TD colspan="3">	
			
				<table>
				<tr><td>
				
				 <cf_intelliCalendarDate9
					FieldName="poststart" 
					class="regularxl"
					Default="01/01/2000"
					AllowBlank="True">	
					
				</TD>
				
				<TD class="labelmedium" style="padding-left:10px;padding-right:10px"><cf_tl id="and">:</TD>
				<TD>
				
				<cf_intelliCalendarDate9
					FieldName="postend" 
					class="regularxl"
					Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
					AllowBlank="True">	
					
				</TD>
				</tr>	
				</table>
			
			</td>
			</tr>
			
		</table>
	
	</CFFORM>

</td></tr>

<tr><td  height="30" align="center">
	<input type="reset" value="Reset" class="button10g">	   
	<input type="button" onclick="search()" name="Submit" value="Search" class="button10g">
	</td>
</tr>

<tr><td height="1" class="line"></td></tr>
<tr><td height="100%" id="details"></td></tr>

</table>


