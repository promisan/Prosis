<cfset thisDivName	="#LEFT(REPLACE(url.mission,"__","","ALL"),25)#YKK">

<cfset mission = "">

<cfloop index="itm" list="#url.mission#" delimiters="__">

	<cfif mission eq "">
		<cfset mission = "'#itm#'">
	<cfelse>
		<cfset mission = "#mission#,'#itm#'">
	</cfif>	
	
</cfloop>

 <cfif url.orgunit eq "0">
	<cfset org ="">
<cfelse>
    <cfset org = url.orgunit>
</cfif>

<cfquery name="Base" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT    TS.SalesPersonNo, P.IndexNo, P.LastName, P.FirstName
	FROM      ItemTransaction AS T INNER JOIN
	          ItemTransactionShipping AS TS ON T.TransactionId = TS.TransactionId INNER JOIN
	           Employee.dbo.Person AS P ON TS.SalesPersonNo = P.PersonNo
			   
				  <!--- 
					 <cfif url.OrgUnit neq "">				   
				   INNER JOIN
			                      Organization.dbo.Organization AS O ON Sub.OrgUnit = O.OrgUnit INNER JOIN
			                      Organization.dbo.Organization AS P ON O.Mission = P.Mission AND O.MandateNo = P.MandateNo AND O.HierarchyRootUnit = P.OrgUnitCode
						</cfif>		  		   
						--->
			   
			   
	WHERE      Mission IN (#preserveSingleQuotes(mission)#)  AND  T.TransactionType = '2'
	
	<cfif url.period eq "All">
		AND    Year(T.TransactionDate) >= '2015'
	<cfelse>
		AND    Year(T.TransactionDate)  = '#url.period#' 
	</cfif>
	
	<!---
	<cfif org neq "">	
		AND    P.OrgUnit = '#url.orgunit#'				  					  
	</cfif>
	--->
			
	GROUP BY TS.SalesPersonNo, P.IndexNo, P.LastName, P.FirstName		
  
</cfquery>

<cfquery name="Actor" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Person
	<cfif quotedValueList(Base.SalesPersonNo) eq ""> 
	WHERE  1=0
	<cfelse>
	WHERE  PersonNo IN (#quotedValueList(Base.SalesPersonNo)#)
	</cfif>
	ORDER BY LastName
</cfquery>

<cfset link = "#session.root#/Portal/Topics/SalesOfficer/SalesContent.cfm?mission=#url.mission#&period=#url.period#&orgunit=#url.orgunit#&divname=#thisDivName#">

<cfoutput>

	<table width="100%">	
	    
	    <tr><td style="padding-left:4px">
		
			    <table width="100%">
			    <tr class="fixlengthlist">
				
				<td class="labelit" style="color:gray;padding-left:3px;padding-right:10px"></td>
				<td style="padding-left:7px;padding-right:4px" class="labelit">
					<input type="radio" class="radiol" name="layout_#thisDivName#" id="layout_#thisDivName#" value="Store" 
						onclick="if ($('##divSalesOfficerDetail_#thisDivName#').length > 0) { ptoken.navigate('#link#&status='+$('##fldstatus_#thisDivName#').val()+'&actor='+$('##fldactor_#thisDivName#').val()+'&sort='+$('##fldsort_#thisDivName#').val()+'&stage='+$('##fldstage_#thisDivName#').val()+'&layout=Store','divSalesOfficerDetail_#thisDivName#');}"
						checked></td>
				<td class="labelmedium" style="padding-right:4px"><cf_tl id="Store"></td>
				
				<td style="padding-left:7px;padding-right:4px" class="labelit">
					<input type="radio" class="radiol" name="layout_#thisDivName#" id="layout_#thisDivName#" value="Category" 
						onclick="if ($('##divSalesOfficerDetail_#thisDivName#').length > 0) { ptoken.navigate('#link#&status='+$('##fldstatus_#thisDivName#').val()+'&actor='+$('##fldactor_#thisDivName#').val()+'&sort='+$('##fldsort_#thisDivName#').val()+'&stage='+$('##fldstage_#thisDivName#').val()+'&layout=Category','divSalesOfficerDetail_#thisDivName#');}">
				</td>
				<td class="labelmedium" style="padding-right:4px"><cf_tl id="Category"></td>				
				
				<td style="padding-left:7px;padding-right:4px" class="labelit">
					<input type="radio" class="radiol" name="layout_#thisDivName#" id="layout_#thisDivName#" value="Schedule" 
						onclick="if ($('##divSalesOfficerDetail_#thisDivName#').length > 0) { ptoken.navigate('#link#&status='+$('##fldstatus_#thisDivName#').val()+'&actor='+$('##fldactor_#thisDivName#').val()+'&sort='+$('##fldsort_#thisDivName#').val()+'&stage='+$('##fldstage_#thisDivName#').val()+'&layout=PriceSchedule','divSalesOfficerDetail_#thisDivName#');}">
				</td>
				<td class="labelmedium" style="padding-right:4px"><cf_tl id="Schedule"></td>	
				
				<td style="padding-left:10px" class="labelit"><cf_tl id="Content"></td>
								
				<td class="labelit" style="color:gray;padding-left:12px">	
				  <select class="regularxl" id="fldsort_#thisDivName#" onchange="doChangeSO('#link#','#URL.mission#',document.getElementById('fldactor_#thisDivName#'),this,document.getElementById('fldstage_#thisDivName#'),'#thisDivName#')">					 		
				      <option value="Margin" selected><cf_tl id="Margin"></option>
					  <option value="Sales"><cf_tl id="Sales">$</option>	
					  <option value="Quantity"><cf_tl id="Sales">##</option>						 
				  </select>	
				</td>		
				
				<td style="padding-left:10px" class="labelit"><cf_tl id="Status"></td>
								
				<td class="labelit" style="color:gray;padding-left:12px">	
				  <select class="regularxl" id="fldstage_#thisDivName#" onchange="doChangeSO('#link#','#URL.mission#',document.getElementById('fldactor_#thisDivName#'),document.getElementById('fldsort_#thisDivName#'),this,'#thisDivName#');">					 		
				      <option value="Pending" selected><cf_tl id="Pending"></option> <!--- sale not settled AR balance --->
					  <option value="Completed"><cf_tl id="Completed"></option>	<!--- settled --->
					  <option value=""><cf_tl id="Both"></option>						 
				  </select>	
				</td>	
				
				<td style="padding-left:10px" class="labelit"><cf_tl id="Seller"></td>									
										
					<cfquery name="User" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   UserNames
						WHERE  Account = '#session.acc#'	
					</cfquery>
											
					<td class="label" style="color:gray;padding-left:12px">	
					  <cf_tl id="Any" var="1">
					  <select class="regularxl" id="fldactor_#thisDivName#" style="width:130px" 
					      onchange="doChangeSO('#link#','#URL.mission#',this,document.getElementById('fldsort_#thisDivName#'),document.getElementById('fldstage_#thisDivName#'),'#thisDivName#')">					 		
					       <option value="">-- #lt_text# --</option>
						  <cfloop query="Actor">				  
						  	<option value="#PersonNo#" <cfif user.personno eq personno>selected</cfif>>#LastName#</option>					  
						  </cfloop>
					  </select>
					  
					</td>		
					
					<input type="hidden" id="fldstatus_#thisDivName#" value="0">	
					
						
					
															
					
				</tr>
				</table>
			</td>
		</tr>
	</table>
</cfoutput>