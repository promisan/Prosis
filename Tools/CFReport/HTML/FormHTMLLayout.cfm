<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfparam name="layoutfilter" default=""> 
<cfparam name="url.portal"				 default="0">
	  
  <cfquery name="Report" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   U.*, R.* 
	 FROM     UserReport U INNER JOIN
	          Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId INNER JOIN
	          Ref_ReportControl R ON L.ControlId = R.ControlId
	 WHERE    U.ReportId = '#URL.ReportId#' 
   </cfquery>
	
   <cfset SelLayoutId            = "#Report.LayoutId#">	
   <cfset SelFileFormat          = "#Report.FileFormat#">	
	  
   <cfquery name="Layout" 
			 datasource="AppsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM  Ref_ReportControlLayout R
			 WHERE ControlId = '#url.ControlId#'
			 AND   Operational = 1
			 AND   LayoutName != 'Export Fields to MS-Excel' 
			 <cfif layoutfilter neq "">
			 AND  ( 
			        LayoutId IN (SELECT LayoutId 
			                     FROM   Ref_ReportControlLayoutCluster 
							     WHERE  Layoutid = R.LayoutId
							     AND    CriteriaName = '#layoutfilter#'
							  ) 
					OR
					
					 LayoutId NOT IN (SELECT LayoutId 
			                          FROM   Ref_ReportControlLayoutCluster 
							          WHERE  Layoutid = R.LayoutId
							  ) 	
							  
					)		  	  
			 </cfif>
			 <cfif url.portal eq "1">
			 	AND UserScoped = 1
			 </cfif>				 
			 UNION
			 SELECT *
			 FROM  Ref_ReportControlLayout R
			 WHERE ControlId = '#url.ControlId#'
			 AND   Operational = 1
			 AND   LayoutName = 'Export Fields to MS-Excel'
			 AND   ControlId IN (SELECT ControlId FROM Ref_ReportControlOutput)
			 <cfif layoutfilter neq "">
			 AND  ( 
			        LayoutId IN (SELECT LayoutId 
			                   FROM     Ref_ReportControlLayoutCluster 
							   WHERE    Layoutid = R.LayoutId
							   AND      CriteriaName = '#layoutfilter#'
							  ) 
					OR
					
					LayoutId NOT IN (SELECT LayoutId 
			                         FROM   Ref_ReportControlLayoutCluster 
							         WHERE  Layoutid = R.LayoutId
							  ) 	
							  
					)		  	  
			 </cfif>
			 <cfif url.portal eq "1">
			 	AND UserScoped = 1
			 </cfif>				 
			 ORDER BY ListingOrder 
   </cfquery>
	    
   <cfif layout.recordcount eq "0">
	    <cfset cl = "hide">  		
   <cfelse>
	    <cfset cl = "regular">	
   </cfif>

  <cfoutput> 
    
  <tr class="#cl#">
  
  </cfoutput>
  
   		<cf_tl id="Select one of the predefined layouts for your data" var="1">		
					
		<td>
		   
		   <table width="100%" cellspacing="0" cellpadding="0">		
		   
		   <tr class="line">
		   <td colspan="3" height="4" style="padding-left:5px;font-size:25px;height:45px;font-weight:200;">	
		   <cf_tl id="Layout and formatting"></td>
		   </tr>
		   <cfset initLayoutclass = Layout.LayoutClass>
		   
		   <tr>			
		  
		   <td style="padding-left:10px;padding-top:7px" class="labelit" valign="top">
		  
		   <cfoutput>	
		      <select name="layoutid" class="regularxl" style="width:98%;background-color:efefef;font-size:18px;height:40px" id="layoutid" onchange="getclass(this.value,'#SelFileFormat#','#controlid#','#reportid#')">
		   </cfoutput>
		  										
		   <cfoutput query="Layout">		   
		  
			   	<option value="#layoutId#" <cfif SelLayoutId eq LayoutId or currentrow eq "1">selected</cfif>>
					
				<cfif LayOutClass eq "View">
			    <b><cf_tl id="View"></b>:#LayoutName#
			    <cfelseif TemplateReport eq "Excel">
				<cf_tl id="Analyse">/<cf_tl id="Export data">	
				<cfelse>
				#LayoutName#
			   </cfif>		
			   
			    </option>	
						   			  
		   </cfoutput>
		   
		   </select>
		   
		   </td>
						   
		   <td>
						
			<table cellspacing="0" cellpadding="0" align="left">
			
			    <tr><td id="fmode" class="labelit" style="padding-left:4px;padding-top:3px">
				
				<cfparam name="url.layoutid" default="#SelLayoutId#">
				<cfif url.layoutid eq "">
				     <cfset url.layoutid = layout.layoutid>
				</cfif>
				<cfset url.sel = SelFileFormat>
				
				<cfinclude template="FormHTMLLayoutFormat.cfm">
				
				</td></tr>		
		    </table>
			
			</td>			
			   
		   </tr>
		 
		   </table>
		   							
		</td>
		
		</tr>
		
</table>	 