
<!--- my dialog for entering stuff for this document line --->

<cfquery name="Color" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   UserAnnotation
	 WHERE  Account = '#SESSION.acc#'	
	 AND    Operational = 1
	 ORDER BY ListingOrder
</cfquery>

<!---	
<cf_screentop height="100%" scroll="no" html="yes" layout="webapp" blur="Yes" bannerheight="55" banner="blue" label="Internal Memo" option="Annotate and prioritise this document">
--->

<cfoutput>
	
<form action="#session.root#/tools/annotation/AnnotationSubmit.cfm?box=#url.box#&entity=#url.entity#&key1=#url.key1#&key2=#url.key2#&key3=#url.key3#&key4=#url.key4#" 
    method="POST" target="annotationprocess" style="height:98%">
				
	<table width="95%" height="98%" align="center">
			
	<cfset ann = "">  	
		
	<tr><td colspan="3" style="padding-top:8px">
	
		<cfquery name="Other" 
				 datasource="AppsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT R.Description, 
				        R.Color,
						U.OfficerLastName, 
						U.OfficerFirstName, 
						U.Annotation,
						U.Created
				 FROM   UserAnnotationRecord U, UserAnnotation R
				 WHERE  U.Account      = R.Account
				 AND    U.AnnotationId = R.AnnotationId
				 AND    U.Account      != '#SESSION.acc#'
				 AND    U.EntityCode   = '#url.entity#'			 
				 AND    U.Scope        = 'Shared'
				 <cfif key1 neq "">
				 AND    U.ObjectKeyValue1 = '#url.key1#'	
				 </cfif>
				 <cfif key2 neq "">
				 AND    U.ObjectKeyValue2 = '#url.key2#'	
				 </cfif>
				 <cfif key3 neq "">
				 AND    U.ObjectKeyValue3 = '#url.key3#'	
				 </cfif>
				 <cfif key4 neq "">
				 AND    U.ObjectKeyValue4 = '#url.key4#'	
				 </cfif>
				 ORDER BY U.OfficerUserId	 		
	    </cfquery>	
		
		<table width="98%" cellspacing="0" cellpadding="0" class="formpadding">
		
		<tr><td colspan="3"><font face="Verdana" size="2"><b>Shared Notes</font></td></tr>
		
		<cfloop query="other">
		
			<tr>
				<td height="20">
					<table>
					 <tr><td bgcolor="#color#" height="13" width="7" style="border: 1px solid gray;"></td></tr>
					</table>
				</td>
				<td class="labelmedium" width="60%">#Description#</td>
				<td class="labelmedium">#OfficerFirstName# #OfficerLastName#</td>				
				<td align="right" class="labelmedium">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>				
			</tr>
			
			<cfif Annotation neq "">
				<tr><td></td><td colspan="3" class="labelit">#Annotation#</td></tr>		
			</cfif>
		
		</cfloop>
	
	</table>
	
	</td>
	</tr>
	
	<tr><td style="border-top:1px dotted silver"></td></tr>
	
	<tr><td align="center" height="35">
	
		<!--- top menu --->
				
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">	
		
		<tr>
		
			<cfset ht = "48">
			<cfset wd = "48">
		
		    <cf_menutab item       = "1" 
		            iconsrc    = "Memo.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "1"
					class      = "highlight1"
					name       = "My Personal Memo">	
					
			<cfset itm = 2>	
				
			<cf_menutab item       = "2" 
		            iconsrc    = "Notes.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 	
					padding    = "1"				
					name       = "My Shared Notes">		
					
			<td width="20%"></td>		
		
		</tr>		
		
		</table>
		
	</tr>							
	
	<tr><td height="1" colspan="1" class="linedotted"></td></tr>

	<tr><td height="100%">	
	
			<cf_divscroll style="height:100%"> 		
	
			<table width="100%" 
		      border="0"
			  height="100%"
			  cellspacing="0" 
			  cellpadding="0" 
			  align="center">	 
					  
				<cf_menucontainer item="1" class="regular">
				
					<cfinclude template="AnnotationDialogPersonal.cfm">
				
				</cf_menucontainer>
				
				<cf_menucontainer item="2" class="hide">
				
					<cfinclude template="AnnotationDialogShared.cfm">
				
				</cf_menucontainer>
						
			</table>
			
			</cf_divscroll>
			
			</td>
			
		</tr>		
		
	<tr><td align="center">
		<input type="submit" name="Save" id="Save" value="Save" class="button10g" style="width:200px;font-size:15px;height:27px">	
	</td></tr>
	
	<tr><td class="hide"><iframe width="100%" name="annotationprocess" id="annotationprocess"></iframe></td></tr>	
	
	</table>	
			
</form>

</cfoutput>


		
	
	


