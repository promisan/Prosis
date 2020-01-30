

<cfif url.id1 neq "tree">
	<cf_OrganizationSelect OrgUnit = "#URL.ID1#">
</cfif>

<cfif URL.View eq "All">	
	<cfset rows = "999">
<cfelse>
	<cfset rows = "1">
</cfif>
	
<cfquery name="SearchResult"
        datasource="AppsOrganization"
		maxrows="#rows#"
		username="#SESSION.login#"
        password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     #CLIENT.LanPrefix#Organization O 
		         INNER JOIN UserQuery.dbo.#SESSION.acc#AllotmentOrgView#FileNo# V ON O.OrgUnit   = V.OrgUnit
		WHERE    O.Mission        = '#URL.Mission#'
		  AND    O.MandateNo      = '#URL.Mandate#'		  
		  <cfif url.id1 neq "Tree">
		  AND    O.HierarchyCode >= '#HStart#'
		  AND    O.HierarchyCode  < '#HEnd#' 
		  </cfif>
		  <!--- disabled 
		  AND (O.DateExpiration > '#DateFormat(DisplayPeriod.DateEffective,client.dateSQL)#' OR O.DateExpiration is NULL)
		  AND  O.DateEffective < '#DateFormat(DisplayPeriod.DateExpiration,client.dateSQL)#'
		  --->
	    ORDER BY O.HierarchyCode 
</cfquery>

<!--- ----------------------------------- --->
<!--- -------Mark down list-------------- --->
<!--- ----------------------------------- --->

<cfquery name="MarkDown" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     tmp#SESSION.acc#Allotment#FileNo# 			
</cfquery>

<cfset client.markdownlist = "#QuotedValueList(MarkDown.ProgramCode)#">

<!--- ----------------------------------- --->
<!--- -------Mark down list-------------- --->
<!--- ----------------------------------- --->

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
	
	<TR class="line"><td width="6%" height="20"></td>
	
	    <TD class="labelit"><cf_tl id="Code" var="1"><cf_space spaces="30" label="#lt_text#"></TD>
		
		<td colspan="3" width="80%" class="labelit" style="border-right: 1px solid Silver;"><cf_tl id="Program Name"></td>
		
		<cfloop query="Resource">
			<cfoutput>	    
				<td align="center" class="labelit" style="min-width:90px;cursor:pointer;border-right: 1px solid Silver;">
				<cfif len(name) gt "15">
				   <cfset nme = "#left(name,15)#..">
				<cfelse>
				   <cfset nme = name>
				</cfif>
				<cf_space label="#nme#" class="lABELIT" align="center" tip="#description#">		
				</td>			
			</cfoutput>
		</cfloop>	
			 
		<td align="right" class="labelit" style="min-width:100px;border-right: 1px solid Silver;">
			 <cf_space class="labelit"  align="center" label="Total">
		</td>
		 
	</TR>
	
	
	<cfoutput query="SearchResult" group="HierarchyCode">
	
		   <!--- get user Authorization level for BUDGET information --->
	         
		   <cfinvoke component = "Service.Access"
				Method             = "Organization"
				OrgUnit            = "#OrgUnit#"
				Period             = "#URL.Period#"
				Role               = "BudgetManager"
				ReturnVariable     = "BudgetAccess">	
							
		   <!--- If no Manager access, check for officer access --->
			<cfif BudgetAccess neq "NONE">
			
		       <cfset BudgetAccess = "Manager">
			   
			<cfelse>   
			
			   <cfinvoke component="Service.Access"
					Method="Organization"
					OrgUnit="#SearchResult.OrgUnit#"
					Period="#URL.Period#"
					Role="BudgetOfficer"
					ReturnVariable="BudgetAccess">
				
				<!--- adjusted to 7/10/2014 --->	
				<cfif BudgetAccess eq "ALL">
					<cfset BudgetAccess = "Manager">
				<cfelseif BudgetAccess eq "EDIT">
					<cfset BudgetAccess = "Officer">	
				</cfif>					
				
			</cfif>	
					
	   <cfset Spaces = Len(HierarchyCode)-1>
	  
	   <cfif spaces lte "3">
	  	    <cfset color = "D3E9F8">
	   <cfelseif spaces lte "6">
	  	  	<cfset color = "D3E0F8">
	   <cfelseif spaces lte "9">	
	  	  	<cfset color = "e6e6e6">
	   <cfelse>
	  	   <cfset color = "eaeaea">	
	   </cfif>   	
	    			   		
	   <cfif searchresult.total gt "0" AND (url.id1 eq "tree" or url.filter eq "all")>
	   
	   	  	 		   
	   	   <cfif SearchResult.Total neq "" or url.filter eq "all">
		  		   		       
		   <tr class="line" style="background-color:D3E9F8">
		   
		     <cfif spaces eq "1">
			     				 
				 <td colspan="5" class="labelmedium" style="background-color:#color#;border-right:1px solid silver;height:38;font-size:18px;padding:3px;padding-left:10px">
				         <cfif orgunitnameshort neq "">#OrgUnitNameShort#/</cfif>#OrgUnitName# 
				 </td>
				 
			 <cfelseif spaces eq "4">
			     				 
				 <td colspan="5" class="labelmedium" style="background-color:#color#;border-right:1px solid silver;height:34;font-size:16px;padding:3px;padding-left:10px">
				         &nbsp;.&nbsp;. &nbsp;&nbsp;#OrgUnitCode#  <cfif orgunitnameshort neq "">#OrgUnitNameShort#/</cfif>#left(OrgUnitName,60)#
				 </td>	 
				
			 <cfelse>
			 
			       <td class="labelmedium"  style="background-color:#color#;height:20;padding-left:10px;height:32;font-size:14px;" colspan="5">					   		   				  
				   		 <cfloop index="sp" from="1" to="#Spaces#" step="3">&nbsp;. </cfloop>&nbsp;&nbsp;#OrgUnitCode#  <cfif orgunitnameshort neq "">#OrgUnitNameShort#/</cfif>#left(OrgUnitName,60)#
				   </td>
				   
			 </cfif>
			 
		      <cfloop index="item" from="1" to="#Resource.RecordCount#" step="1">
			  
				    <td align="right" class="labelmedium" style="background-color:#color#;padding-right:2px;border:1px solid Silver;">
					
						<cfset val = Evaluate("Resource_" & Item)>
							
						<cfif Parameter.BudgetAmountMode eq "0">
							<cf_numbertoformat amount="#val#" present="1" format="number0">
						<cfelse>				
							<cf_numbertoformat amount="#val#" present="1000" format="number1">
						</cfif> 											
						#val# 
							
					</td>
					
		      </cfloop>
			  
			  <td align="right" class="labelmedium" bgcolor="eaeaea" style="background-color:#color#;padding-right:2px;border-right: 1px solid Silver;">
						 
				 	<cfif Parameter.BudgetAmountMode eq "0">
						<cf_numbertoformat amount="#SearchResult.Total#" present="1" format="number0">
					<cfelse>
						<cf_numbertoformat amount="#SearchResult.Total#" present="1000" format="number1">
					</cfif> 	
					#val#
					
		      </td>
			  
		 	</TR>  
			
			
			 	 
			<cfquery name="Program" 
				 datasource="AppsQuery" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   *
					 FROM     tmp#SESSION.acc#Allotment#FileNo# 
					 WHERE    1=1
					 <cfif url.view neq "Prg">			 
					 AND      OrgUnit = '#SearchResult.OrgUnit#' 			
					 </cfif>	
					 <cfif url.view eq "All">
					 AND      (ProgramScope = 'Unit' or Total != 0)
					 </cfif>
					 AND      Class != 'Next'
					 ORDER BY ProgramHierarchy
			</cfquery>
						
			<cfif program.recordcount gte "1">			
				<cfloop query="Program">																							
					  <cfinclude template="AllotmentViewListingDetail.cfm"> 				  
				</cfloop>
			</cfif>
			
			</cfif>
		
		 
		</cfif>	 
		
	
	</CFOUTPUT>

</TABLE>