
<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">

<cfquery name="Template" 
	datasource="appsControl">
	SELECT   *
	FROM     Ref_TemplateContent
	WHERE    ObservationId  = '#url.observationid#'
	AND      ActionCode     = '#URL.actionCode#'
	AND      PathName       = '#URL.PathName#' 
	AND      FileName       = '#URL.FileName#'	
</cfquery>
		
<cfif template.recordcount eq "0">

  <tr><td class="labelit" class="linedotted" align="center"><b>No history found</td></tr>

<cfelse>  
	
	<!---
	<tr bgcolor="white">
	    <td></td>
		<td><b>Modified on</td>
		<td><b>Officer</b></td>
		<td><b>Size</td>	
	</tr>
	--->
					
		<cfloop query="Template">
		
			<tr bgcolor="ffffcf" class="labelit">
			    <td width="20" align="center" style="padding-right:4px">
				<img src="#SESSION.root#/Images/pointer.gif" alt="" align="absmiddle" border="0">
				</td>
				<td width="100" class="labelit">
				<cfif find(".cfr",filename)>
					#dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")#
				<cfelse>
					<a href="javascript:templatedetail('#TemplateId#','prior')" title="Retrieve template details">
					  #dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")#
					</a>
				</cfif>
					
				</td>
				<td width="120" class="labelit">#TemplateModifiedBy#</td>
				<td width="80" class="labelit">#numberformat(TemplateSize/1024,"_._")# kb</td>
				<td class="labelit">#TemplateComments#</td>
			</tr>
			
		</cfloop>
		
	</tr>

</cfif>

</table>

</cfoutput>

