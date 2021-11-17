<cfparam name="url.action" default="">
<cfparam name="URL.ID" default="">

<cfquery name="Check" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Broadcast
	  WHERE  BroadcastId     = '#URL.Id#'   
</cfquery>

<cfif Check.recordcount eq "0">
	<script>
	alert("Broadcast was removed. Action aborted")
	ptoken.navigate('BroadCastHistory.cfm?mode=#url.mode#','contentbox2')
	window.close()
	</script>
	<cfabort>
</cfif>

<cfset link = "BroadCastRecipientLine.cfm?id=#url.id#">

<cfif url.action eq "Insert">
	
	<cfquery name="Member" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * FROM UserNames
	  WHERE Account  =  '#url.Account#'	 
	</cfquery>
	
	<cfif Member.eMailAddressExternal neq "">
	 <cfset mail = Member.emailAddressExternal>
	<cfelse>
	 <cfset mail = Member.emailAddress> 
	</cfif>
	
	<cfif Member.recordcount eq "1">

		<cfquery name="Employee" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO BroadcastRecipient
		
		    (BroadcastId,
			 RecipientCode,
			 eMailAddress,
			 RecipientName, 
			 RecipientLastName, 
			 RecipientFirstName)
			 
		VALUES(	
		'#URL.Id#',
		'#Member.Account#',
		'#mail#',
		'#Member.FirstName# #Member.LastName#',
		'#Member.LastName#',
		'#Member.FirstName#') 
		</cfquery>
	
	</cfif>
		
</cfif>	

<cfquery name="Broadcast" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  Broadcast
	  WHERE BroadcastId = '#URL.ID#'  
</cfquery>

<cfquery name="Recipient" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	  SELECT *
	  FROM  BroadcastRecipient
	  WHERE BroadcastId = '#URL.ID#' 
	  ORDER BY RecipientCode, RecipientLastName,RecipientFirstName,RecipientName
</cfquery>

<cfquery name="Group" 
   datasource="AppsSystem" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT COUNT(*)
		FROM   BroadCastRecipient
		WHERE  BroadCAstId =  '#URL.ID#' 
		GROUP  BY RecipientCode
		HAVING COUNT(*) > 1
</cfquery>

<cfset currrow = 0>

<cfparam name="URL.page" default="1">
	
<cfset counted = recipient.recordcount>
<cf_PageCountN count="#recipient.recordcount#" show="22">
<cfset per = URL.Page*20-20>
<cfset perT = "">

<cf_divscroll>

	<table width="98%" align="center" cellspacing="0" cellpadding="0" class="navigation_table">
	
	 <tr class="hide"><td height="6" id="selected"></td></tr>
	
	 <tr><td colspan="6"><cfinclude template="BroadCastNavigation.cfm"></td></tr>
	 
	 <tr height="20" class="line labelmedium2 fixlengthlist">
	 	 <cfif Group.RecordCount gt 0>
	 	 <td></td>
		 </cfif>
	     <td align="center">No.</td>
		 <td></td>	
	     <td><cf_tl id="Name"></td>
		  <cfif Group.RecordCount eq 0>
		  	<td><cf_tl id="Code"></td>
		  </cfif>
		 <td><cf_tl id="Address"></td>
		 <td align="center"><cfif broadcast.BroadcastStatus eq "1">Sent<cfelse>Include</cfif></td>
	 </tr>
	  
		<cfoutput query="recipient" group="RecipientCode">
		 
		 	<cfset currrow = currrow + 1>
					
			<cfif currrow gte first and currrow lte last>
			
				<cfif Group.RecordCount gt 0>
				<tr>
					<td colspan="6" class="labelmedium2" style="font-size:16px;font-weight:bold;padding-left:4px">#RecipientCode# #RecipientName#</td>
				</tr>
				</cfif>
			
				<cfoutput>
				
					<cfif check.broadcastStatus eq "0"> 
					<tr id="r#currentrow#" class="navigation_row navigation_action line labelmedium2 fixlengthlist">
					<cfelse>
					<tr id="r#currentrow#" class="navigation_row line labelmedium2 fixlengthlist"> 
					</cfif>
						<cfif Group.RecordCount gt 0>
							<td></td>
						</cfif>
					    <td height="20" align="center">#currentrow#</td>
						<cfif BroadCast.systemFunctionId neq "">
						<td><img src="#SESSION.root#/Images/locate3.gif" height="12" WIDTH="12" alt="" style="cursor: pointer;" border="0" 
						     onclick="preview('#url.id#','#Recipient.recipientId#')"></td>
						<cfelse>
						<td></td>		 
					    </cfif>
						<TD><cfif RecipientLastName neq "">#RecipientLastName#<cfif RecipientFirstName neq "">, #RecipientFirstName#</cfif><cfelse>#RecipientName#</cfif></TD>
						
						<cfif Group.RecordCount eq 0>
		  					<td>#RecipientCode#</td>
		  				</cfif>
						
						<TD title="#emailaddress#">#EMailAddress#</TD>
						<td align="center">
						<cfif broadcast.BroadcastStatus eq "0">
						  <input type="checkbox"
						       name="select" id="select" class="radiol"
							   value="#Selected#" onClick="recipienttoggle('#recipientid#',this.checked)" <cfif selected eq "1">checked</cfif>>
						<cfelse>
							<cfif selected eq "1">Yes<cfelse><font color="FF0000">No</font></cfif>
						    
						</cfif>   	
						</td>
					</tr>
				
				</cfoutput>
				
				<cfif RecipientCode neq "">
				
				<cf_fileExist
					DocumentPath="Broadcast\#URL.ID#\#RecipientCode#"
					SubDirectory="" 						
		    		Filter = "">	
			
					<cfif files gte "1">
					
					<tr><td></td><td></td>
					  <td colspan="4" id="box#currentrow#">			
									
						<cf_filelibraryN    	
								DocumentPath="Broadcast"
								SubDirectory="#URL.ID#\#RecipientCode#" 
								ShowSize="0"
								Box="box#currentrow#"
								Filter=""
								width="250"
								LoadScript="no"
								Insert="no"
								Remove="yes">	
					
					</td>
					</tr>
				
						
					</cfif>	
						 
				</cfif>
			
			</cfif>
		  
		</cfoutput>
	 
	</table>

</cf_divscroll>
	
<cfset ajaxonload("doHighlight")>