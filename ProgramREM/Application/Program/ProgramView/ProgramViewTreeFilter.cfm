
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	  
	  <!--- 28/6/2012 we need to refresh this as well --->
	  	 	  
	  <cfquery name="Filter" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	 	  SELECT  DISTINCT P.ProgramClass
		  FROM    Program P INNER JOIN
    	          ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode
		  WHERE   Pe.Period = '#URL.Period#'
	  </cfquery>
	  
	  <cfparam name="client.programclass" default="">
	 	 	  
	  <cfif Filter.Recordcount gte "1">
	  	 		    
			   <tr>
			   
			   <td colspan="2" style="padding-left:20px">
		  		  <select style="width:190px;" class="regularxl" name="ProgramClass" id="ProgramClass" onChange="refreshListing()">
					  <option value="All" selected><cf_tl id="All"></option>
					  <option value="Component"  <cfif client.programclass eq "component">selected</cfif>><cf_tl id="Components"></option>
					   <cfif Parameter.enableGANTT eq "1">
					    <option value="Project" <cfif client.programclass eq "project">selected</cfif>><cf_tl id="Only Projects"></option>
					   </cfif>
			      </select>
		  	  </td>
			  </tr>
						 
	 <cfelse>	
	 
	     <input type="hidden" name="ProgramClass" id="ProgramClass" value="All"> 
	 	 
	 </cfif>  
	 
	 <cfparam name="client.programgroup" default="">
	
	 <cfquery name="Class" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
    	  SELECT   * 
		  FROM     Ref_ProgramGroup
		  WHERE    (Period = '#URL.Period#' or Period is null)
		  AND      (Mission = '#URL.Mission#' or Mission is NULL)
		  ORDER BY ListingOrder
	 </cfquery>
  
     <cfif Class.recordcount gt "0">	 	 	  
	  	  	  
		   <tr>
		     
			   <td colspan="2" style="padding-left:20px">
				  <select style="width:190px" class="regularxl" name="ProgramGroup" id="ProgramGroup" onChange="refreshListing()">
					  <option value="All" selected><cf_tl id="All program groups"></option>
					  <cfoutput query="Class">
					     <option value="#Code#" <cfif client.programgroup eq code>selected</cfif>>#Description#</option>
					  </cfoutput>
				  </select>
			  
			   </td>
		  </tr>
	 		 	  	  
  	<cfelse>
			
		 <input type="hidden" name="ProgramGroup" id="ProgramGroup" value="All">
			
  	 </cfif>  
	 
	 <tr><td height="4"></td></tr>
		 	 
	 <tr><td class="linedotted" height="1" colspan="2"></td></tr>
	 	  
	<!--- select the plan period --->
		  	 	  
          <cfset PNo = 0>
	   
	      <tr><td height="2"></td></tr>
		  <tr><td colspan="2">
		  
			  <table cellspacing="0" cellpadding="0">
				  <cfset row = "0">
				  
		          <cfoutput query = "Period"> 
				  
					  <cfset PNo = PNo+1>
					  <cfset row = row+1>
					  
					  <cfif row eq "1">
			          
					  <tr>
					  
					  </cfif>
					  
			          <td id="Period#PNo#" style="padding-left:5px;<cfif url.period eq period>font='bold'</cfif>"> 		
					  
					  	<table cellspacing="0" cellpadding="0" class="formpadding">
						<tr><td> 						
						<input type="radio" name="Period" id="Period" value="#Period#" class="radiol"
							onClick="ClearRow('Period',#Period.RecordCount#);Period#PNo#.style.fontWeight='bold';updatePeriod(this.value,'#MandateNo#')"													
							<cfif url.period eq period>Checked</cfif>>							
							</td>
							<td class="cellcontent" style="padding-left:8px">#Description#</td>			         		
							<cfif url.period eq period>							
								<input type="hidden" name="PeriodSelect" id="PeriodSelect" value="#Period#">
								<cfset per     = Period>
								<input type="hidden" name="MandateNo" id="MandateNo" value="#MandateNo#">
								<cfset man     = "#MandateNo#">														
							</cfif>							
					    </tr>
						</table>							
					  </td>
					  <cfif row eq "2">
					  </tr><cfset row = "0">
					  </cfif>
				      
			      </cfoutput> 
				  
			  </table>
		  </td>
	   </tr>
	   
	   <tr><td class="linedotted" colspan="2"></td></tr>  
	   
	  </table>
	 