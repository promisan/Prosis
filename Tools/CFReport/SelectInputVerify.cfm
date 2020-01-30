
<!--- 1. pass the controlid, criterianame and values
      2. generate a correct list and exclude the "*" and count the entries
	  3. run query with list and count matching entries
	  4. if different, make a message.
	  --->
	  
<cfparam name="url.add" default="">	  
<cfparam name="url.del" default="">
<cfparam name="err" default="0">

<cfset cl = "blue">

<cfif url.add neq "">

	<cfif url.val eq "">
	
		<cfset value = url.add>
		
	<cfelse>
	
	    <cfif findnocase(url.add,url.val)>
		    <!--- do not add --->
			<cfset value = url.val>
		<cfelse>
			<cfset value = "#URL.val#,#url.add#">
		</cfif>	
			
	</cfif>		
		
<cfelse>

	<cfset value = URL.val>
	
</cfif>	

<cfset value=Replace(Value,"'",'','ALL')>
<cfset value=Replace(Value," ",'','ALL')>
<cfset value=Replace(Value,"#chr(10)#",',','ALL')>
<cfset value=Replace(Value,"#chr(13)#",',','ALL')>
<cfset value=Replace(Value,",,",',','ALL')>
	
<cfset val = "">
<cfset prs = "">

<cfif url.del eq "*">
   <cfset selectall = 0> 
<cfelseif right(value,1) eq "*">   
   <cfset selectall = 1>	
<cfelse>
   <cfset selectall = 0>      
</cfif>

<cfset value=Replace(Value,"*",'','ALL')>

<cfset cnt = "0">

<cfloop index="itm" list="#value#" delimiters=",">
  <cfif url.del neq itm>
	  <cfset cnt = cnt+1>
	  <cfif val eq "">
	      <cfset prs = "#itm#"> 
	      <cfset val  = "'#itm#'">
	  <cfelse>
	      <cfset prs = "#prs#,#itm#"> 
	      <cfset val = "#val#,'#itm#'">
	  </cfif>
  </cfif>
</cfloop> 

<cfquery name="Get" 
	datasource="AppsSystem">
		SELECT *
		FROM   Ref_ReportControlCriteria 
		WHERE  ControlId    = '#URL.ControlID#'
		AND    CriteriaName = '#URL.CriteriaName#'
</cfquery>
		
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfoutput>
		
	<tr><td class="labelit">
	
	<cfif prs eq "">
	
		<font color="6688aa">[<cf_tl id="No preselection">]</font>
	
	<cfelse>
	
	    <cfset err = 0>
		<cfset vItemCount = 0>
	
		<cfloop index="itm" list="#prs#" delimiters=",">
		
		 <cfset cl = "red">
				 		
		 <cfif get.LookupTable neq "" and itm gte "a">
				
			<cftry>    	
				<cfquery name = "Check" 
					 datasource   = "#get.LookupDatasource#" 
					 username     = "#SESSION.login#" 
					 password     = "#SESSION.dbpw#">
					 SELECT top 1 *
					 FROM  #Get.LookupTable#				 
					 WHERE #Get.LookupFieldValue# = '#itm#'				
					</cfquery>	
												
					<cfif check.recordcount eq "0">
					  <cfset cl = "red">
					<cfelse>
					  <cfset cl = "black">  	
					</cfif>  	
				
				<cfcatch>
				
				  <cfset cl = "blue">  
				  
				</cfcatch>
			</cftry>
				
		  <cfelseif get.CriteriaType eq "Integer">
				  
			  <cfif isValid("integer", itm)>
			      <cfset cl = "black">  
			  <cfelse>
			       <cfset cl = "red">	
				   <cfset err = 1>  
			  </cfif>  
		  
		  <cfelseif get.CriteriaValidation neq "">
		  
			  <cfif isValid(get.CriteriaValidation, itm)>
			      <cfset cl = "black">  
			  <cfelse>
			       <cfset cl = "red">	
				   <cfset err = 1>   
			  </cfif>  	
			  
		  <cfelse>
		  
		      <cfset cl = "blue">  
					  
		  </cfif>  
		  
		  <cfset vItemCount = vItemCount + 1>
		
	      <a href="##" title="remove" onClick="_cf_loadingtexthtml='';verifycont('#ControlId#','#CriteriaName#','','#itm#','')">
		  <font color="#cl#">#itm#</font></a><cfif vItemCount lt ListLen(prs,',')>,</cfif>
			
		</cfloop>
		
		<cfif selectall eq "1">
			<a href="##" onclick="_cf_loadingtexthtml='';verifycont('#ControlId#','#CriteriaName#','','*')" title="remove">*</a>
		</cfif>
		
	</cfif>
	
	</td></tr>
			
	<tr><td class="hide">
	
		<textarea rows="3" 
				name="#CriteriaName#" 
				id="#CriteriaName#" 
				class="regular" 
				style="width:99%">#prs#<cfif selectall eq "1">,*</cfif></textarea> 
				
	</td></tr>
		
	<tr><td class="labelit">
			
	 <cfif get.LookupTable neq "" and cl neq "blue">
		    	
		<cfquery name="Check" 
		 datasource="#get.LookupDatasource#" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT count(*) as total
		 FROM  #Get.LookupTable#
		 <cfif val neq "">
		 WHERE #Get.LookupFieldValue# IN (#preserveSingleQuotes(val)#) 
		 </cfif>
		</cfquery>		
				
		<cfif check.total eq cnt>
		  <font color="008080"><b>Good, all your selections are valid</font>
		  </td>
				 
		<cfelse>
		
			<cfif val neq "">
		
				<cfquery name="List" 
				 datasource="#get.LookupDatasource#" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT TOP 1 #Get.LookupFieldValue# as PK
				 FROM   #Get.LookupTable#			 
				</cfquery>
			
			 	 <font color="D90000">One of more selections do not exist in the defined lookup table (example value: #List.PK#). Please review your input</font>
				 
			 </cfif>
							  
		</cfif>
		
	<cfelse>
	
	     <cfif err eq "1">
		  <font color="D90000">Errors have been detected for validation [#get.CriteriaValidation#] </font>	
		 </cfif>		
		
	</cfif>		
		
	</cfoutput>
		
	</td></tr>
	
</table>
