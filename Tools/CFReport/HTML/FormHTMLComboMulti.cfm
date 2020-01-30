
<cfquery name="Base" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     TOP 1 *
	 FROM  		Ref_ReportControlCriteria R
	 WHERE  	ControlId     = '#URL.ControlId#' 
	  AND    	CriteriaName  = '#URL.CriteriaName#'  
</cfquery>
	
<cfparam name="URL.Page" default="1">

<cfif Base.LookupDataSource eq "">
	<cfset ds = "appsQuery">
<cfelse>
	<cfset ds = "#Base.LookupDataSource#">
</cfif> 

<!--- determine the all button --->

<cfif Base.CriteriaType eq "Unit">	

	<!--- define current mandate for select --->
	
	<cfquery name="Mandate"
		datasource="appsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT TOP 1 *
	    FROM   Ref_Mandate		
		WHERE  Mission = '#url.fly#' 
		AND    DateEffective  <= getdate()
		ORDER BY DateExpiration DESC			
	</cfquery>			

	<!--- generates a list of valid orgunits --->
	
    <cf_selectOrgUnitBase 
	controlid="#url.controlid#" 
	criteriaName="#url.criteriaName#">
		
    <cfquery name="total"
		datasource="appsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT count(DISTINCT OrgUnit) as total 
	    FROM   Organization
		<cfif selectedorg neq "all" and selectedorg neq "" and selectedorg neq "''">
		WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
		<cfelse>
		WHERE Mission   = '#Mandate.Mission#' 
		AND   MandateNo = '#Mandate.MandateNo#'
		</cfif>
	</cfquery>	
		
<cfelse>

     <cfoutput query="Base">

		 <cfinclude template="FormHTMLComboQuery.cfm">
	 
	 </cfoutput>
									
	<cfquery name="Total" 
	    datasource="#ds#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT count(DISTINCT #Base.LookupFieldValue#) as total
	   	FROM #Base.LookupTable#
		<cfif crit neq "">
		 #preserveSingleQuotes(con)#
		<cfelse>
		 WHERE 1=1
		</cfif>
	</cfquery> 

</cfif>
	
<table border="0"
       width="100%"
	   height="100%"	 
	   bgcolor="white"	  
	   class="formpadding">  	
 
<tr><td colspan="2" bgcolor="white" valign="top" style="padding:1px;height:60%">

	    <form name="multiform" id="multiform" style="height:100%">
		
	    <table width="100%" 	  
		   border="0"	
		   style="height:100%"   	      
	       align="center">
		   
		<tr><td>			
		   
		    <input type="hidden" 
			 value="<cfoutput>#URL.CriteriaDefault#,</cfoutput>" 
			 name="multivalue" 
			 id="multivalue">			
			 
			 </td></tr>   
		   
		<tr class="hide"><td id="selectedvalues"></td></tr>   
			
		<tr>
	  
		   <td>
		   		<table>
					<tr>
						
						<td valign="middle" style="padding-left:14px">
						
						    <cfoutput>
							<input type="text"  
							   class="regular" 
							   value="" 
							   name="multifind" 
							   id="multifind"
							   onKeyUp="multisearch('#url.criterianame#','#url.fly#','1')" 
							   style="width:300px; height:30px; font-size:14px; font-face:calibri;">
							  </cfoutput> 
							   
						</td>
						<td style="height:40" valign="middle">
						
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Search-R.png?id=1" 
								height="32" 
								title="find" 
								style="cursor:pointer;"
								onclick="document.getElementById('find').focus();">
						</td>
						<input type="hidden" id="multivariant" value="1">
						<!---
						<td class="labelmedium" style="padding-left:5px">
							<input type="checkbox" name="multivariant" id="multivariant" value="1" onClick="multisearch('#url.criterianame#','#url.fly#','1')"><cf_tl id="advanced">
						</td>
						--->
					</tr>
				</table>
		   </td>
		   
		   <td height="28" colspan="1" align="right" style="padding-right:4px"></td>
		     
		</tr>
		
		<tr><td height="5"></td></tr> 	
			 	
		<cfif Base.CriteriaHelp neq "">
			<tr><td colspan="3" class="labelmedium" style="border: 1px solid #silver; font-size:14px; font-face:calibri;">: <cfoutput query="Base"><b>#CriteriaHelp#</cfoutput></td></tr>	
			<tr><td height="5"></td></tr> 	
		</cfif>
			
		<TR><td height="100%" valign="top" colspan="3">
		
			<cf_divscroll style="height:50%" id="multiresult">
			
				<cfset url.par = URL.CriteriaName>
				<cfparam name="Form.Multivalue" default="#url.criteriadefault#">
				<cfinclude template="FormHTMLComboMultiResult.cfm">
			
			</cf_divscroll>
					
		</td></tr>
				
		</table>	
				 
	   </form>
		
	</td>
   </tr>
 
	
	<tr>
	 <td colspan="2" height="40%" valign="top" style="padding-left:10px;padding-right:20px">
	 
	  <cf_divscroll id="multiselectbox" style="position:absolute;overflow: auto; width:98%; height:154; scrollbar-face-color: F4f4f4;">
			
		 <!--- pass the initial values as already on the screen/variant --->			 	
 		 <cfset Selected     = "#URL.CriteriaDefault#">		 		 		 
		 <cfset mode         = "edit">
		 <cfinclude template = "FormHTMLComboMultiSelected.cfm">		 
		 
	 </cf_divscroll>	 
		 
	 </td>
	</tr>
	<tr><td colspan="3" align="center"></td></tr>
	
	<tr>	
	<td height="30" colspan="2" align="center" bgcolor="FFFFFF" style="border; border: 0px solid Gray;">	
	    <table class="formpadding">
		<tr>
			<td>
			<input type="button" class="button10g" name="Close"  id="Close"  onclick="try { ProsisUI.closeWindow('combomulti',true)} catch(e){};" value="Close">
			</td>
			<td style="padding-left:3px">
			<cfoutput>
			<input type="button" class="button10g" name="Return" id="Return" onclick="multiapply('#URL.criterianame#','#url.fly#')" value="Save">
			</cfoutput>
			</td>
		</tr>
		</table>
	</td>
	</tr>	
		
</table>	
	
<cf_screenbottom layout="webapp">	
