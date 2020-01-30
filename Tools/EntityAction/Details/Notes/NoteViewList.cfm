<cfparam name="url.filter"        default="">

<input type="hidden" name="selecteditem" id="selecteditem" value="">

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
				
	<tr>
	
	<td valign="top">	
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0">
		
		<tr><td height="20" style="padding:2px" width="100%"><cfinclude template="NoteMenu.cfm"></td></tr>
												
		<tr><td height="20">
		
			<table width="100%" class="formpadding" cellspacing="0" cellpadding="0">
			<tr>
			<td width="95%" style="padding:5px">
			<input class="regularxl" type="text" name="filter" id="filter" style="width:100%" value="#url.filter#">
			</td>
			<td width="30" align="center" onclick="javascript:doSearch()">
				<cfoutput>
					<img src="#SESSION.root#/images/locate.gif" height="13" width="13" alt="" border="0">
				</cfoutput>
			</td>
			</tr>
			</table>
		
		</td></tr>
		
		<tr><td class="linedotted"></td></tr>
		
		<tr><td height="100%">
			 
			<cf_divscroll id="notecontainerdetail" overflowy="scroll">				
				<cfinclude template="NoteList.cfm">
			</cf_divscroll>
			
		</td></tr>
		</table>  
		
	</td>
	</tr>		
	
</table>

</cfoutput>

<cfset ajaxonload("enable_enter")>