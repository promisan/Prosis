

<cfparam name="url.line"     default = "1">
<cfparam name="url.setlabel" default = "1">
<cfparam name="url.mission"  default = "">
<cfparam name="url.location" default = "0">

<!--- request item detail --->

<cfquery name="Master" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ItemMaster
		WHERE     Code = '#url.itemmaster#'
</cfquery>

<cfquery name="Entry" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ProgramAllotmentRequest
		<cfif URL.id neq "">
			WHERE     RequirementId  = '#url.id#' 	
		<cfelse>
			WHERE     0 = 1
		</cfif>	
</cfquery>

<cfquery name="List" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ItemMasterList
		WHERE     ItemMaster = '#url.itemmaster#'
		AND       Operational = 1
		ORDER BY  ListOrder
</cfquery>

<!--- apply labels --->

<cfif url.setlabel eq "1">
	
	<cfset row = 0>
	<cfloop index="itm" list="#master.BudgetLabels#" delimiters="|">
	   <cfset row = row+1>
	      <cfset lbl[row] = itm>	 
	</cfloop>
	
	<cfparam name="lbl[1]" default="Item">
	<cfparam name="lbl[2]" default="Quantity">
	<cfparam name="lbl[3]" default="Memo">
	<cfparam name="lbl[4]" default="Days">
	
	<cf_tl id="#lbl[1]#" var="label_itm">
	<cf_tl id="#lbl[2]#" var="label_qty">
	<cf_tl id="#lbl[3]#" var="label_mem">
	<cf_tl id="#lbl[4]#" var="label_day">
			
	<cfoutput>
	
		<script language="JavaScript">			    
			try {  		    
			document.getElementById('labelitem').innerHTML = '#label_itm#'			
			} catch(e) {}
			document.getElementById('labelqty').innerHTML  = '#label_qty#'
			try {
			document.getElementById('labelday').innerHTML  = '#label_day#'		
			} catch(e) {}
			document.getElementById('labelmemo').innerHTML = '#label_mem#'
		</script>
		
	</cfoutput>

</cfif>

<cfif Master.BudgetTopic eq "DSA">

		<table width="100%" cellspacing="0" cellpadding="0">
		<tr><td style="padding-right:3px">
   		
		<cf_InputDSA name = "topicvaluecode_#url.line#" 
		     selected     = "#entry.topicvaluecode#"
			 function     = "applycost"
			 class        = "regularxl"
			 passtru      = "#url.itemmaster#"
			 line         = "#url.line#">			 
			    		
		<cfoutput>	 
		<script language="JavaScript">
			applycost('#url.itemmaster#',this.value,'#url.line#','#url.mission#','#url.location#')
		</script>	
		</cfoutput> 	
		
		</td>
		</tr>
		</table>						
			
<cfelseif List.recordcount eq "0" or Master.BudgetTopic neq "Standard">
		
		<cfoutput>
	   
	   	    <table width="100%" cellspacing="0" cellpadding="0">
				<tr>
				<td width="100%">
		   	     <cf_tl id="Please enter a description" var="1">
				 <input type = "Text"
			       name      = "RequestDescription_#url.line#"		   	   
				   maxlength = "200"	
				   class     = "regularxl enterastab"
				   style     = "width:98%;height:25;padding-left:4px;border:1px solid silver"	
				   size      = "40"   
			       value     = "#entry.requestDescription#">
				</td>
				<!--- maybe best to enforce this on the level of Idbo.temMasterObject	
				<td><font color="FF0000">*)</font></td> 
				--->
				</tr>
			</table>    
						   
		 </cfoutput>  
		 				   
<cfelse>
		
		<cfoutput>	
		
				
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr><td>
					
			<cfset sel = list.topicvaluecode>
											
			<select name="TopicValueCode_#url.line#"  class="regularxl enterastab" style="width:98%" 
				onchange="applycost('#url.itemmaster#',this.value,'#url.line#','#entry.topicvaluecode#','#url.mission#','#url.location#')">
				
				<option value="">--<cf_tl id="select option">--</option>
				<cfloop query="List">
							   
				    <cfif entry.topicvaluecode neq "">					    
						
						<cfif topicvaluecode eq entry.topicvaluecode>
							<cfset sel = entry.topicvaluecode>
						</cfif>					
					
						<option value="#TopicValueCode#" <cfif topicvaluecode eq entry.topicvaluecode>selected</cfif>>#TopicValue#</option>								
					
					<cfelse>
					
						<cfif listdefault eq "1">
							<cfset sel = topicvaluecode>						
						</cfif>
					    
						<option value="#TopicValueCode#" <cfif listdefault eq "1">selected</cfif>>#TopicValue#</option>
																			
					</cfif>
					
				</cfloop>
				
			</select>		

			<input type="hidden" value="na" name="RequestDescription_#url.line#" id="RequestDescription_#url.line#">  	
			
			</td>		
		</tr>	
		</table>	
		
		<cfif url.id neq "">		
								
			<script language="JavaScript">
				applycost('#url.itemmaster#','#sel#','#url.line#','#entry.topicvaluecode#','#url.mission#','#url.location#') 
			</script>			
		
		</cfif> 	
				
		</cfoutput>		
		
</cfif>
	