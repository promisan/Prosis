
<cf_screentop height="100%" scroll="Yes" html="no">

<cfoutput>

<cfparam name="client.verbose" default="0">
<cfparam name="client.widthfull" default="#client.width#">
<cfset home = "yes">


<cfparam name="URL.PersonNo" default="#client.PersonNo#">

<script>
	
	function load(per,code,tree,mandate) {
		window.location = "PortalViewDetail.cfm?Period="+per+"&Mode=Indicator&Portal=1&ProgramGroup=All&ProgramClass=All&ID=#URL.ID#&ID1="+code+"&ID2="+tree+"&ID3="+mandate			   
	}
	
	function overview(per,code, tree, mandate) {
		window.location = "PortalViewDetail.cfm?Period="+per+"&Mode=Indicator&Portal=1&ProgramGroup=All&ProgramClass=All&ID=#URL.ID#&ID1=Tree&ID2="+tree+"&ID3="+mandate			   
	}				
	
	function maximize(itm){
		 
		 se   = document.getElementsByName(itm)
		 icM  = document.getElementById(itm+"Min")
		 icE  = document.getElementById(itm+"Exp")
		 count = 0
			 
		 if (icM.className == "regular") {
			
		 icM.className = "hide";
		 icE.className = "regular";
		 
		 while (se[count]) {
		   se[count].className = "hide"
		   count++ }
		 
		 } else {
		 	 
		 while (se[count]) {
			 se[count].className = "regular"
			 count++ }
			 icM.className = "regular";
			 icE.className = "hide";			
		 }
	  }  
		
</script>	

<cfset header1 = "002350">
<cfset header1Size = "2">
<!---
<cf_LoginTop height="100%" 
             FunctionName = "#URL.ID#">
			 --->

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">

<!---
<tr><td valign="top" height="50"><cfinclude template="PortalViewBanner.cfm"></td></tr>
--->

<tr>
<td valign="top" height="100%">
		
	<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<!---
	
	<cfset mis = "''">
	<cfloop index="itm" list="#System.FunctionCondition#"> 
	
	  <cfif mis eq "''">
	    <cfset mis = "'#itm#'">
	  <cfelse>
	    <cfset mis = "#mis#,'#itm#'">
	  </cfif>
	</cfloop>
	
	--->
	
	<cfquery name="Periods" 
	datasource="AppsProgram">
	SELECT P.*
	FROM   Organization.dbo.Ref_MissionPeriod M, Ref_Period P
	
	WHERE  M.Mission = '#url.mission#'
	<!---
	WHERE  M.Mission IN (#preservesingleQuotes(mis)#)
	--->
	AND    M.Period = P.Period 	     
    AND    P.DateEffective < GETDATE() 
	AND    P.DateExpiration > GETDATE() 	
    </cfquery>
			
	<cfloop query="Periods">
						
		<cfset URL.show = "1">
		<cfset URL.Text = "Current Period">
		<cfset URL.ID1 = "0">
		<cfset URL.FileNo = "2">
		
		<cfif URL.Show eq "1">
			<cfset cl = "regular">
			<cfset clt = "hide">
		<cfelse>
			<cfset cl = "hide">
			<cfset clt = "regular">
		</cfif>
		
		<tr id="e#currentrow#">
		 <td>
		 <table width="100%" border="0" cellspacing="0" cellpadding="0">
		 <tr><td height="20"></td></tr>
		 <tr>
		 <td align="center" width="30">
		 
		 		<img src="#SESSION.root#/Images/expand5.gif" alt="Expand" 
		            onMouseOver="document.e#currentrow#Exp.src='#SESSION.root#/Images/expand-over.gif'" 
				    onMouseOut="document.e#currentrow#Exp.src='#SESSION.root#/Images/expand5.gif'"
					name="e#currentrow#Exp" border="0" class="#clt#" 
					align="absmiddle" style="cursor: pointer;"
					onClick="maximize('e#currentrow#')">
					
				<img src="#SESSION.root#/Images/collapse5.gif" 
					onMouseOver="document.e#currentrow#Min.src='#SESSION.root#/Images/collapse-over.gif'" 
				    onMouseOut="document.e#currentrow#Min.src='#SESSION.root#/Images/collapse5.gif'"
					name="e#currentrow#Min" alt="Collapse" border="0" 
					align="absmiddle" class="#cl#" style="cursor: pointer;"
					onClick="maximize('e#currentrow#')">
					
	
		 	  </td>			
		  <td style="cursor: pointer;" onClick="maximize('e#currentrow#')">
		    <font face="Ms Trebuchet" size="#header1Size#" color="#header1#"><b>Period <cfoutput>#Description#</cfoutput>
		 </td>
		  </tr>
		</table>
		</td>	
		</tr>
		<tr id="e#currentrow#" class="#cl#"><td><font face="Verdana" size="1">&nbsp;&nbsp;&nbsp;&nbsp;
		Click the Unit to view the status</td></tr>
		<tr id="e#currentrow#" class="#cl#"><td height="3"></td></tr>
		
		<tr id="e#currentrow#" class="#cl#">
		<td>
		    <table width="98%" align="right">
			<tr><td>	
							
				<cfinclude template="PortalViewListing.cfm"> 		
								
			</td></tr>
			</table>
		</td>
		</tr>	
	
	</cfloop>
	
	<tr><td height="4"></td></tr>
	<tr><td height="4"></td></tr>
	
	<cfquery name="Prior" 
	datasource="AppsProgram">
	SELECT P.*
	FROM   Organization.dbo.Ref_MissionPeriod M, Ref_Period P
	WHERE  M.Mission = '#url.mission#'
	<!---
	WHERE  M.Mission IN (#preservesingleQuotes(mis)#)
	--->
	AND    M.Period = P.Period 	  
	AND    DateExpiration < GETDATE()  
	</cfquery>
		
	<cfif Prior.recordcount gte "1">			
		
		<cfset URL.show = "0">
		<cfset URL.Text = "Other Periods">
		<cfset URL.ID1 = "1">
		<cfset URL.FileNo = "3">
		<cfset currentrow = 1>
		
		<cfif URL.Show eq "1">
			<cfset cl = "regular">
			<cfset clt = "hide">
		<cfelse>
			<cfset cl = "hide">
			<cfset clt = "regular">
		</cfif>
		
				
		<tr><td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		 <tr>
		 <td align="center" width="30">
		
		 <img src="#SESSION.root#/Images/expand5.gif" alt="Expand" 
		            onMouseOver="document.d#currentrow#Exp.src='#SESSION.root#/Images/expand-over.gif'" 
				    onMouseOut="document.d#currentrow#Exp.src='#SESSION.root#/Images/expand5.gif'"
					name="d#currentrow#Exp" border="0" class="#clt#" 
					align="absmiddle" style="cursor: pointer;"
					onClick="maximize('d#currentrow#')">
					
					<img src="#SESSION.root#/Images/collapse5.gif" 
					onMouseOver="document.d#currentrow#Min.src='#SESSION.root#/Images/collapse-over.gif'" 
				    onMouseOut="document.d#currentrow#Min.src='#SESSION.root#/Images/collapse5.gif'"
					name="d#currentrow#Min" alt="Collapse" border="0" 
					align="absmiddle" class="#cl#" style="cursor: pointer;"
					onClick="maximize('d#currentrow#')">
					
		 </td>			
		 <td style="cursor: pointer;" onClick="maximize('d#currentrow#')">
		 <font face="Ms Trebuchet" size="#header1Size#" color="#header1#"><b>Prior Period
		 </td>	
		  </tr>
		</table>
		</td></tr>
		<tr id="d#currentrow#" class="#cl#"><td><font face="Verdana" size="1">&nbsp;&nbsp;&nbsp;&nbsp;Click the Unit to view the status</td></tr>
		<tr id="d#currentrow#" class="#cl#"><td height="3"></td></tr>
		
		<tr id="d#currentrow#" class="#cl#">
		<td>
		    <table width="98%" align="right">
			<tr><td>	
			
				<cfinclude template="PortalViewListing.cfm"> 				
					
			</td></tr>
			</table>
		</td>
		</tr>	
		
	</cfif>
	
	</table>
</td>	
</tr>
</table>

</cfoutput>	 
