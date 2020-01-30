<cfset display = true>

<cfset alias = url.alias>

<cfset topictable       = evaluate("url.topictable#url.serialno#")>
<cfset topictablename   = evaluate("url.topictable#url.serialno#name")>

<cfset topicscope       = evaluate("url.topicscope#url.serialno#")>
<cfset topicfield       = evaluate("url.topicfield#url.serialno#")>
<cfset topicscopetable  = evaluate("url.topicscope#url.serialno#table")>
<cfset topicscopefield  = evaluate("url.topicscope#url.serialno#field")>

<cfif alias eq "appsMaterials">				
	
	<cfquery name="Topic" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    SELECT *
		FROM   Ref_Topic
		WHERE  Code = '#code#'
	
	</cfquery>
			
	<cfswitch expression="#topicscope#">
		
		<cfcase value="Item">
								
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				
				<tr><td height="25" colspan="3" align="left" class="labelmedium"><b>Asset Item Topic</b></td> 
				    <td colspan="2"></td>
				</tr>
				<tr><td height="1" colspan="3" class="linedotted"></td></tr>
				
				<cfset classlink = "#SESSION.root#/tools/Topic/Materials/ItemClass.cfm?alias=#alias#&Topic=#Code#">
						
				<tr> 
				
				<td height="25" colspan="3" align="left" class="labelit">
	
				   <cf_selectlookup
					    class    = "Item"
					    box      = "l#code#_item"
						title    = "Select Item Master"
						link     = "#classlink#"								
						des1     = "ItemNo">
							
				</td>
				</tr> 	
							
				<tr>
				    <td width="100%" colspan="3">					
					<cfdiv bind="url:#classlink#" id="l#code#_item"/>									
				</td>
				</tr>  
			
			</table>
			
			<input type="hidden" name="ClassForm" id="ClassForm" value="Saved">
				
		</cfcase>
		
		<cfcase value="EntryClass">		
							
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" rules="rows">
				
					<tr class="line"><td height="25" colspan="3"  align="left">Entry Class</b></td>
					<td colspan="2"></td></tr>										
					<tr>
						<cfset link = "#SESSION.root#/Tools/Topic/Materials/EntryClass.cfm?topic=#code#">						
						<td height="25" colspan="3" align="left"> <cfdiv bind="url:#link#" id="#code#_entryclass" > </td>
					</tr>
					
				</table>
				
				<input type="hidden" name="ClassForm" id="ClassForm" value="Saved">
									
		</cfcase>
		
	</cfswitch>
	
<cfelseif alias eq "appsProgram">				
	
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
						
			<cfswitch expression="#topicscope#">
			
				<cfcase value="Ref_Object">
													
					<cfset classlink = "#SESSION.root#/tools/Topic/Program/TopicListingClassObject.cfm?alias=#alias#&Code=#Code#">
							
					<tr class="linedotted"><td style="height:25" colspan="2" align="left" class="labelit">
					
					   <cf_selectlookup
							    class    = "Object"
							    box      = "l#code#_object"
								title    = "Associate Object of Expenditure"
								link     = "#classlink#"								
								dbtable  = "Program.dbo.Ref_TopicObject"
								des1     = "ObjectCode">
								
					</td>
					</tr> 	
								
							
					<tr>
				    <td width="100%" colspan="2">					
						<cfdiv bind="url:#classlink#" id="l#code#_object"/>									
					</td>
					</tr>		
					
				</cfcase>
				
				<cfcase value="Ref_ContributionClass">
					
					<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" rules="rows">
				
						<tr><td height="25" colspan="3"  align="left"><font face="Calibri" size="3"><b>Contribution Class</b></td> <td colspan="2"></td></tr>
						<tr><td height="1" colspan="3" class="linedotted"></td></tr>
							
						<tr>
							<cfset link = "#SESSION.root#/Tools/Topic/Program/ContributionClass.cfm?topic=#code#">
								
							<td height="25" colspan="3" align="left"> <cfdiv bind="url:#link#" id="#code#_contributionclass" > </td>
						</tr>
							
					</table>
					
					<input type="hidden" name="ClassForm" id="ClassForm" value="Saved">
					
				</cfcase>
				
			</cfswitch>
		
	</table>	
	
	<input type="hidden" name="ClassForm" id="ClassForm" value="Saved">

<cfelseif alias eq "appsPurchase">	
		
	<table width="100%" align="center">
	
		<tr class="line"><td colspan="3"  align="left"><cfoutput><b>#topicscope#</b></cfoutput></td> <td colspan="2"></td></tr>
		
		<tr>
			<cfset link = "#SESSION.root#/Tools/Topic/Purchase/Class.cfm?topic=#code#&scopetable=#topicscopetable#">
			
			<td height="25" colspan="3" align="left"> <cfdiv bind="url:#link#" id="#code#_class" > </td>
		</tr>
		
	</table>
	
<cfelseif alias eq "appsworkorder">

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
		<tr><td colspan="3" align="left" class="labelmedium" style="padding-top:5px;font-size:23px"><cfoutput><b>#topicscope#</b></cfoutput></td>
		<td colspan="2"></td></tr>
				
		<tr>
			<cfset link = "#SESSION.root#/Tools/Topic/Workorder/Class.cfm?topic=#code#&scopetable=#topicscopetable#">			
			<td colspan="3" align="left">
			  <cfdiv bind="url:#link#" id="#code#_class">
			</td>
		</tr>
		
	</table>
	
<cfelseif alias eq "appscasefile">

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
		<tr><td colspan="3"  align="left" class="labelmedium"><cfoutput><b>#topicscope#</b></cfoutput></td> <td colspan="2"></td></tr>
		<tr><td height="1" colspan="3" class="linedotted"></td></tr>
			
		<tr>
			<cfset link = "#SESSION.root#/Tools/Topic/CaseFile/Class.cfm?topic=#code#&scopetable=#topicscopetable#">
			
			<td height="25" colspan="3" align="left">
			  <cfdiv bind="url:#link#" id="#code#_class">
			</td>
		</tr>
				
		
	</table>	
			
<cfelse>
			
		
	<cfif alias eq "appsEmployee">
	
		<cfset display = false>
		
	<cfelse>
	
		<cfquery name="Class" 
			datasource="#url.alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    	SELECT O.*, 
				       (SELECT #topicscopefield# 
					    FROM   #topicscope#
						WHERE  #topicfield# = '#code#' 
						AND    #topicscopefield# = O.#topicscopefield#) as Selected
			    FROM  #topicscopetable# O		
							
				
			</cfquery>	
	
	</cfif>		  
			
	<cfset col = 1>
	
	<cfif display>
	
	<table width="100%">
	
	<tr><td style="padding:4px">
	
		<table cellspacing="0" width="100%">	
			
			<tr class="line"><td colspan="10"></td></tr>			
			
			<cfoutput query="Class">
			
				<cfset cde = evaluate(topicscopefield)>
			
				<cfif col eq "1"><tr></cfif>
					<cfset col = col+1>
					<td height="22" width="10">
									
					<cftry>										
					  <input type="checkbox" name="TopicClassValues" id="TopicClassValues" onClick="javascript:ptoken.navigate('#SESSION.root#/Tools/Topic/TopicListingSubmitClass.cfm?alias=#url.alias#&topicscope=#topicscope#&topicscopetable=#topicscopetable#&topicscopefield=#topicscopefield#&topicfield=#topicfield#&Topic=#URL.Code#&class=#cde#&checked='+this.checked,'process')" value="#code#" <cfif selected neq "">checked</cfif>>
					<cfcatch>
					  <input type="checkbox" name="TopicClassValues" id="TopicClassValues" onClick="javascript:ptoken.navigate('#SESSION.root#/Tools/Topic/TopicListingSubmitClass.cfm?alias=#url.alias#&topicscope=#topicscope#&topicscopetable=#topicscopetable#&topicscopefield=#topicscopefield#&topicfield=#topicfield#&Topic=#URL.Code#&class=#cde#&checked='+this.checked,'process')" value="#evaluate('#topicscopefield#')#" <cfif selected neq "">checked</cfif>>								 
					</cfcatch>
					</cftry>
					
					</td>
					<td style="padding-left:7px" class="labelit" colspoan="2" align="left">#evaluate(topicscopefield)# <cfparam name="Description" default="">
						#Description#</td>
					
					</td>
					<cfif col eq "4">
					<cfset col = 1>
					</tr>
					
				</cfif>
			</cfoutput>
			
			<tr class="line"><td colspan="10"></td></tr>
		
		</table>
	
	   </td></tr>
	   
	   <tr><td id="process"></td></tr>
	
	</table>
	
		<input type="hidden" name="ClassForm" id="ClassForm" value="Pending">
		
	<cfelse>
	
		<input type="hidden" name="ClassForm" id="ClassForm" value="">
		
	</cfif>	

</cfif>