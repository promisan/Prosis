
<cfparam name="form.multivalue" default="">

	<cfquery name="Base" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT     TOP 1 *
		 FROM  		Ref_ReportControlCriteria R
		 WHERE  	ControlId     = '#ControlId#' 
		  AND    	CriteriaName  = '#CriteriaName#'  
	</cfquery>
		
	<cfoutput query="Base">
	
	<cfif LookupDataSource eq "">
		<cfset ds = "appsQuery">
	<cfelse>
		<cfset ds = "#LookupDataSource#">
	</cfif> 	
					
	<cfset tmp = "">
									 
    <cfloop index="itm" list="#form.multivalue#" delimiters=",">
					
		<cfif itm neq "*"> <!--- Hanno added on 7/10/2008 --->
		
      	   <cfif tmp eq "">
    	    <cfset tmp = "'#itm#'">
	       <cfelse>
	        <cfset tmp = "#tmp#,'#itm#'">
	       </cfif>
		   
		</cfif>
		 
  	</cfloop>
 
	<cfif tmp eq "">
	   <cfset tmp = "''">
	</cfif>	
	 
	<cfif Base.CriteriaType eq "Unit">	
	
		<cf_SelectOrgUnitBase 
		    controlid="#controlid#" 
			criterianame="#criteriaName#">
			
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
	
		<cfquery name="list"
			datasource="appsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			 SELECT DISTINCT OrgUnit as PK, 
			                 OrgUnitCode as Code,
							 HierarchyCode as ListingOrder,
			                 <cfif LookupFieldShow eq "0">
							   OrgUnitName as Display
							 <cfelse>
							   OrgUnitCode+' '+OrgUnitName as Display
							 </cfif>
			 FROM   Organization
			 <cfif selectedorg neq "all" and selectedorg neq "" and selectedorg neq "''">
				WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
			 <cfelse>
				WHERE  Mission   = '#Mandate.Mission#' 
		 		AND    MandateNo = '#Mandate.MandateNo#'
			 </cfif>		  
			 AND   OrgUnit IN (#preserveSingleQuotes(tmp)#)  
			 ORDER BY HierarchyCode				
		 </cfquery>	
		
	<cfelse>
		
		<cfset oldMode = mode>
		<cfset mode = "select">		
		<cfinclude template="FormHTMLComboQuery.cfm">		
		<cfset mode = oldMode>
						
		<cfquery name="list" 
	     datasource="#ds#">
	     SELECT DISTINCT #LookupFieldValue# as PK, 	     	    
			 <cfif LookupFieldShow eq "0">
		           #LookupFieldDisplay# as Display
			 <cfelse>
			     <cfif mode eq "Edit">
			     #LookupFieldDisplay# as Display
				 <cfelse>
				 CONVERT(varchar, #LookupFieldValue#) +  ' - ' + CONVERT(varchar, #LookupFieldDisplay#) as Display
				 </cfif>
			 </cfif>
		 FROM  #LookupTable#
				 
		 <cfif con neq "">
		 #preserveSingleQuotes(con)#
		 <cfelse>
		 WHERE 1=1
		 </cfif>
		 AND #LookupFieldValue# IN (#preserveSingleQuotes(tmp)#) 					 		 
		</cfquery> 
					
	</cfif>
		
	<input type="hidden" name="#criteriaName#" id="#criteriaName#" value="#replace(tmp,"'","",'ALL')#">
	
	<cfset sel = "">
			
	<cfif list.recordcount gt "6" and mode eq "view">
			
	   <div style="position:static; width:100%;height:134; scrollbar-face-color: F4f4f4; overflow-y: scroll; overflow-x: auto;">
		
	</cfif>
	
	<cfif mode eq "edit">
		<cfset border = "0">
	<cfelse>
	    <cfset border = "1">
	</cfif>
	
	<table width="<cfif Mode eq 'Edit'>98%<cfelse>98%</cfif>">
	
	   <tr>	
	   
	   <td style="height:30px;border:#border#px solid silver;border-radius:5px">
	   
	   <table width="100%" class="navigation_table">
	      	   		
	    <cfif mode eq "edit">
		 <cfset col = "5">
		<cfelse>
		 <cfset col = "3">
		</cfif>  
															
		<cfif List.recordcount eq "0">
		
			<tr>
			<td colspan="#col#" align="center" class="labelmedium" style="color:silver;font-size:14px;padding-left:20px"><cf_tl id="No records selected"></font></td>
			</tr>
		
		<cfelse>
		
			<cfif mode eq "edit">
			
				<tr class="line">
				
				<td align="right" style="width:20px">
				
			   		<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Delete.png"
			     		title="Remove all"
					     border="0"
						 height="16"
						 width="16"
					     align="middle"
					     style="cursor: pointer;"
					     onClick="multivalue('deleteall','','#URL.criterianame#','#url.fly#','#url.page#')">		
						 
				</td>	
				
				<td colspan="#col-1#" align="left" class="labelmedium" style="font-size:18px;padding-left:20px">
				#List.recordcount# <cf_tl id="records selected">
				</td>
				</tr>
											
			</cfif>
		
		</cfif>
		
		<cfloop query = "list">

			<cfif sel eq "">
				<cfset sel = "#PK#">
			<cfelse>
			    <cfset sel = "#sel#,#pk#">
			</cfif>	
						
		<tr class="navigation_row line">
		
		<cfif mode eq "edit">
			<td width="8%" align="center"></td>
		</cfif>
		
		<cfif mode eq "edit">
			<td style="padding:3px; font-size:14px;padding-left:5px">			
			<cfif Base.CriteriaType eq "Unit">#Code#<cfelse>#PK#</cfif></td>
			<td>&nbsp;</td>
			<td style="padding:3px; font-size:14px;">#Display#</td>
		<cfelse>
			<td style="padding:3px; font-size:14px;padding-left:5px;">#Display#</td>
		</cfif>	
		
		<cfif mode eq "edit">
		
			<td align="right" style="padding-right:10px">
			
			<cf_img icon="delete" tooltip="Remove #Display#" navigation="Yes"
			     onClick="multivalue('delete','#PK#','#URL.criterianame#','#url.fly#','#url.page#')">
				
			</td>	
		
		</cfif>	 		
		
		</tr>
				
		</cfloop>
	
	</table>
	
	</td>
	
	</tr>
	
	</table>
	
	<cfif list.recordcount gt "6" and mode eq "view">
		</div>
	</cfif>	
		
</cfoutput>		

<cfset ajaxonload("doHighlight")>