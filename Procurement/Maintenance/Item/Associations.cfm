<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ItemMaster
	WHERE Code = '#URL.ID1#'
</cfquery>

<cfoutput>
	
	<table width="100%" border="0" rules="none" bordercolor="silver" cellspacing="0" cellpadding="0" align="center">
		
		<tr><td>
		
		<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<TR>										
		 		
			<td height="25" align="left" id="associate">
			
			     <cfset url.entryclass = get.entryclass>
				 <cfset url.initial = "yes">
				 
				 <cfinclude template="EntryClassSelect.cfm">
				 						
			</td>
			
		</tr>	
			
		<tr>	
			
		    <td>
				<cfdiv bind="url:#link#" 
				       id="l#url.id1#_standard"/>
			</td>
					
		</TR>
				
		<tr><td class="line"></td></tr>
		
		<TR>										
		 
			<cfset link = "#SESSION.root#/Procurement/Maintenance/Item/RecordObject.cfm?itemmaster=#URL.ID1#">
			
			<td height="25" align="left">
				
				   <cf_selectlookup
				    class    = "Object"
				    box      = "l#URL.ID1#_object"
					title    = "Object of Expenditure"
					icon     = "insert.gif"
					link     = "#link#"								
					dbtable  = "Procurement.dbo.ItemMasterObject"
					des1     = "ObjectCode">
							
			</td>
			
		</tr>
		
		<tr>	
			
		    <td>
				<cfdiv bind="url:#link#" 
				       id="l#url.id1#_object"/>
			</td>
					
		</TR>
		
		<tr><td class="line" colspan="1"></td></tr>
		
		<tr><td height="4"></td></tr>		
		<tr><td>Budget Item List: 
		      	  <A href="javascript:ColdFusion.navigate('List.cfm?Code=#get.code#&ID2=','list')">
						 <font color="0080FF">[add new]</font></a>
			 </td>
		</tr>
		<tr>	 
		    <td><cfdiv id="list" bind="url:List.cfm?code=#get.code#"/></td>
		</tr>
					
		</table>
		
		</td></tr>
	
	</table>

</cfoutput>